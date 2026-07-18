# mako notification daemon -- symlinked to ~/.config/mako/config
#
# To view all configuration options:
#   man 5 mako
#
# Timings live here rather than in the sending app: ignore-timeout=1 makes mako
# the single source of truth, so nothing can pin a popup on screen but the rules
# below.
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

# --- Grouping ---------------------------------------------------------------
# mako hides every group member but the first by default; show three so a stack
# of related cards stays readable, with the count on the card at the top.

[grouped]
format=<b>%s</b>\n%b

[group-index=0]
format=<b>%s</b>  <span alpha='55%%'>(%g)</span>\n%b

[group-index=1]
invisible=0

[group-index=2]
invisible=0
