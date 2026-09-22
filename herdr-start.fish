#!/usr/bin/fish
# Start herdr at login. On a fresh server, drop the restored snapshot and build
# zofia-w1..w3, each one tab split into two side-by-side panes.

function server_running
    herdr status server 2>/dev/null | string match -q 'status: running'
end

if server_running
    exec ghostty -e herdr
end

rm -f ~/.config/herdr/session.json
ghostty -e herdr &

while not server_running
    sleep 0.2
end

set initial (herdr workspace list | jq -r '.result.workspaces[].workspace_id')

for n in 1 2 3
    set label zofia-w$n
    herdr workspace create --cwd ~/dev/$label --label $label --no-focus >/dev/null
    set ws (herdr workspace list | jq -r --arg l $label '.result.workspaces[] | select(.label == $l) | .workspace_id')
    set pane (herdr pane list --workspace $ws | jq -r '.result.panes[0].pane_id')
    herdr pane split $pane --direction right >/dev/null
end

for ws in $initial
    herdr workspace close $ws >/dev/null
end

set first (herdr workspace list | jq -r '.result.workspaces[] | select(.label == "zofia-w1") | .workspace_id')
herdr workspace focus $first >/dev/null
