#!/bin/bash
# Battery tuning for the Framework 13 (Ryzen 7040). Idempotent; re-run safely.
# Revert: sudo mv /etc/modprobe.d/mt7925.conf.disabled /etc/modprobe.d/mt7925.conf
#         sudo rm /etc/udev/rules.d/99-panel-power-savings.rules /usr/local/bin/panel-power-savings /etc/sysctl.d/99-powersave.conf
#         sudo sed -i 's/ rcu_nocbs=all//' /boot/loader/entries/*.conf
set -euo pipefail

# Wi-Fi ASPM: stop forcing the MT7925 PCIe link awake. Takes effect after reboot.
if [ -f /etc/modprobe.d/mt7925.conf ]; then
    sudo mv /etc/modprobe.d/mt7925.conf /etc/modprobe.d/mt7925.conf.disabled
fi

# Panel power savings (ABM): 3 on battery, 0 on AC.
sudo tee /usr/local/bin/panel-power-savings >/dev/null <<'EOF'
#!/bin/sh
level=3
[ "$(cat /sys/class/power_supply/ACAD/online)" = 1 ] && level=0
for f in /sys/class/drm/card*-eDP-*/amdgpu/panel_power_savings; do
    [ -w "$f" ] && echo "$level" > "$f"
done
exit 0
EOF
sudo chmod 755 /usr/local/bin/panel-power-savings
sudo tee /etc/udev/rules.d/99-panel-power-savings.rules >/dev/null <<'EOF'
SUBSYSTEM=="power_supply", KERNEL=="ACAD", RUN+="/usr/local/bin/panel-power-savings"
SUBSYSTEM=="drm", KERNEL=="card*-eDP-*", ACTION=="add", RUN+="/usr/local/bin/panel-power-savings"
EOF
sudo udevadm control --reload
sudo /usr/local/bin/panel-power-savings

# Kernel knobs.
sudo tee /etc/sysctl.d/99-powersave.conf >/dev/null <<'EOF'
kernel.nmi_watchdog = 0
vm.dirty_writeback_centisecs = 1500
EOF
sudo sysctl -q --load /etc/sysctl.d/99-powersave.conf

# Offload RCU callbacks so lazy RCU batches them instead of waking idle cores.
# Main boot entries only; the fallback entry stays stock as an escape hatch. Takes effect after reboot.
for entry in /boot/loader/entries/*.conf; do
    case "$entry" in *fallback*) continue ;; esac
    if ! grep -q 'rcu_nocbs=' "$entry"; then
        sudo sed -i '/^options / s/$/ rcu_nocbs=all/' "$entry"
    fi
done

# Browser: write session state every 60s instead of 15s.
glide=~/.config/glide/glide.ts
if ! grep -q 'browser.sessionstore.interval' "$glide"; then
    printf '\nglide.prefs.set("browser.sessionstore.interval", 60000);\n' >> "$glide"
fi

echo "panel_power_savings: $(cat /sys/class/drm/card*-eDP-*/amdgpu/panel_power_savings)"
sysctl kernel.nmi_watchdog vm.dirty_writeback_centisecs
grep -H '^options' /boot/loader/entries/*.conf
echo "Reboot to apply Wi-Fi ASPM and rcu_nocbs. Watch: journalctl -k -f | grep -i mt7925"
echo "Verify rcu_nocbs after reboot: journalctl -k -b | grep -i 'offload rcu'"
