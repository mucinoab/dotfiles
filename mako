# mako notification daemon -- symlinked to ~/.config/mako/config
#
# To view all configuration options:
#   man 5 mako
#
# Timings live here rather than in the sending app: ignore-timeout=1 makes mako
# the single source of truth, so nothing can pin a popup on screen but the rules
# below. Only Claude's "needs an answer" categories get an infinite duration.
#
# Reload after editing:  makoctl reload

sort=-time
layer=overlay
anchor=top-right
max-visible=5

default-timeout=8000
ignore-timeout=1
history=1
max-history=20

font=FiraCode Nerd Font 11
width=420
height=200
margin=6
padding=10,14
border-size=2
border-radius=10
text-alignment=left
markup=1

icons=1
max-icon-size=48
icon-location=left
icon-border-radius=6

background-color=#181b20f5
text-color=#e8eaedff
border-color=#0074d9
progress-color=over #0074d9

[urgency=low]
border-color=#666666
default-timeout=5000

[urgency=normal]
border-color=#0074d9

# mako only knows low/normal/critical -- the [urgency=high] this used to say
# never matched anything, so critical alerts were silently styled as normal.
[urgency=critical]
border-color=#ff4136
default-timeout=20000

# --- Claude Code ------------------------------------------------------------
# Colours mirror claude-activity-hook.sh, so a red border here means the same
# thing as a red glyph in the zjstatus bar. Each session rewrites its own card
# (x-canonical-private-synchronous), and the cards of different sessions group
# by state.

[app-name=claude]
group-by=app-name,category
border-size=2
icons=0

# Waiting on a permission decision or an MCP dialog.
[app-name=claude category=x-claude.input]
border-color=#ff4136
background-color=#241a1aff
default-timeout=0

# Idle -- Claude is waiting on a prompt.
[app-name=claude category=x-claude.idle]
border-color=#ffdc00
background-color=#241f16ff
default-timeout=0

# A subagent needs an answer.
[app-name=claude category=x-claude.agent]
border-color=#b10dc9
background-color=#211826ff
default-timeout=0

# Turn finished. Informational, so it expires.
[app-name=claude category=x-claude.done]
border-color=#2ecc40
background-color=#17231aff
default-timeout=8000

# --- Grouping ---------------------------------------------------------------
# mako hides every group member but the first by default; show three so a stack
# of sessions stays readable, with the count on the card at the top.

[grouped]
format=<b>%s</b>\n%b

[group-index=0]
format=<b>%s</b>  <span alpha='55%%'>(%g)</span>\n%b

[group-index=1]
invisible=0

[group-index=2]
invisible=0
