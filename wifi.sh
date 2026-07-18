#!/bin/bash
# Pick a Wi-Fi network with fzf and connect to it via iwd.
# iwctl prompts for the passphrase itself when the network isn't already known.

set -u

strip_ansi() { sed 's/\x1b\[[0-9;]*m//g'; }

# iwd draws unfilled signal bars as dim-grey asterisks; drop them before
# stripping colours, otherwise every network looks like full signal.
drop_dim_bars() { sed 's/\x1b\[1;90m\*\+\x1b\[0m//g'; }

dev=${1:-}
if [ -z "$dev" ]; then
    for d in /sys/class/net/wl*; do
        [ -e "$d" ] || continue
        dev=${d##*/}
        break
    done
fi
if [ -z "$dev" ]; then
    echo "No wireless interface found." >&2
    exit 1
fi

command -v fzf >/dev/null || { echo "fzf is required." >&2; exit 1; }

current=$(iwctl station "$dev" show | strip_ansi | sed -nE \
    's/^[[:space:]]*Connected network[[:space:]]+(.+[^[:space:]])[[:space:]]*$/\1/p')

echo "Scanning on $dev..."
iwctl station "$dev" scan >/dev/null 2>&1
sleep 2

# SSID \t security \t signal \t connected-marker
nets=$(iwctl station "$dev" get-networks | drop_dim_bars | strip_ansi | sed -nE \
    's/^[[:space:]]*(>?)[[:space:]]*(.+[^[:space:]])[[:space:]]{2,}(psk|open|wep|8021x)[[:space:]]+(\*{0,4})[[:space:]]*$/\2\t\3\t\4\t\1/p')

if [ -z "$nets" ]; then
    echo "No networks found." >&2
    exit 1
fi

# Column 1 is the padded display; the action and real SSID ride along hidden.
menu=$(printf '%s\n' "$nets" |
    awk -F'\t' '{printf "%s %-32s %-6s %s\tconnect\t%s\n", ($4 == ">" ? "*" : " "), $1, $2, $3, $1}')
if [ -n "$current" ]; then
    menu=$(printf '  %-32s\tdisconnect\t%s\n%s\n' "[disconnect from $current]" "$current" "$menu")
fi

choice=$(printf '%s\n' "$menu" |
    fzf --delimiter='\t' --with-nth=1 --reverse --height=40% --prompt='wifi > ')

[ -z "$choice" ] && exit 0
action=$(printf '%s' "$choice" | cut -f2)
ssid=$(printf '%s' "$choice" | cut -f3)

if [ "$action" = disconnect ]; then
    echo "Disconnecting from $ssid..."
    # iwd stops auto-reconnecting until the next explicit connect.
    iwctl station "$dev" disconnect || exit 1
else
    echo "Connecting to $ssid..."
    iwctl station "$dev" connect "$ssid" || exit 1
fi

iwctl station "$dev" show | strip_ansi |
    grep -E 'State|Connected network|IPv4 address' |
    sed 's/^ *//; s/ *$//'
