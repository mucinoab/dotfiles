#!/usr/bin/env bash
# Claude Code -> desktop notification (mako) + sound.
# Registered in ~/.claude/settings.json for the Notification and Stop hooks.
#   Notification: Claude needs input (permission / idle) -> persistent critical alert
#   Stop:         Claude finished a turn                  -> brief informational ding
# mako does not play sounds itself, so we play one explicitly with paplay.

SOUND_DIR=/usr/share/sounds/freedesktop/stereo

INPUT=$(cat)
EVENT=$(printf '%s' "$INPUT"   | jq -r '.hook_event_name // ""' 2>/dev/null)
CWD=$(printf '%s' "$INPUT"     | jq -r '.cwd // ""'             2>/dev/null)
MSG=$(printf '%s' "$INPUT"     | jq -r '.message // ""'         2>/dev/null)
PROJECT=$(basename "$CWD" 2>/dev/null)

case "$EVENT" in
  Notification)
    URGENCY=critical
    ICON=dialog-warning
    SOUND="$SOUND_DIR/message.oga"
    TITLE="Needs you${PROJECT:+ — $PROJECT}"
    BODY="${MSG:-Waiting for your input}"
    ;;
  Stop)
    URGENCY=normal
    ICON=dialog-information
    SOUND="$SOUND_DIR/dialog-warning.oga"
    TITLE="Finished${PROJECT:+ — $PROJECT}"
    BODY="Turn complete"
    ;;
  *)
    exit 0
    ;;
esac

notify-send \
  --app-name="cc" \
  --urgency="$URGENCY" \
  --icon="$ICON" \
  --category=im.received \
  "$TITLE" "$BODY"

# Detach the sound so the hook returns immediately and the sound isn't killed
# when this script exits.
( paplay "$SOUND" >/dev/null 2>&1 & )
