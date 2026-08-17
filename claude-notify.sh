#!/usr/bin/env bash
# Claude Code -> mako desktop notification + sound.
#
# Registered in ~/.claude/settings.json for three hooks. The event is read from
# the payload on stdin, so one script covers all of them:
#
#   UserPromptSubmit  stamp the turn start time and print nothing -- this hook's
#                     stdout is injected into the conversation as context.
#   Notification      Claude wants something. notification_type says what, and
#                     picks the glyph, colour, sound and urgency. Background
#                     agents finishing on their own are not worth a popup.
#   Stop              turn finished. The payload hands us the final assistant
#                     message, so the card can say what actually happened.
#
# Every card carries x-canonical-private-synchronous:claude-<session>, so a
# session rewrites its own card instead of piling up on it. mako then groups the
# cards of different sessions by category -- see ~/Dotfiles/mako for the colours,
# which mirror the ones claude-activity-hook.sh feeds to the zjstatus bar.
#
# Work past the parse happens in a detached stage-2 process (--deliver): probing
# the focused pane costs ~100ms, and the click handler has to outlive the hook.

set -u

# Turn-clock scratch space. XDG_RUNTIME_DIR is per-user and 0700; the fallback
# has to earn that itself, since /tmp is world-writable and this path is
# guessable -- see the guard in the UserPromptSubmit branch.
STATE_DIR="${XDG_RUNTIME_DIR:+$XDG_RUNTIME_DIR/claude-notify}"
STATE_DIR="${STATE_DIR:-/tmp/claude-notify-$(id -u)}"
SOUND_DIR=/usr/share/sounds/freedesktop/stereo

# --- stage 2: deliver -------------------------------------------------------
# Re-exec'd through setsid with CN_* in the environment.

# Pango-escape: bodies are arbitrary prose and routinely contain && and <T>,
# which would otherwise break mako's markup parser.
esc() {
	printf '%s' "$1" | sed -e 's/&/\&amp;/g' -e 's/</\&lt;/g' -e 's/>/\&gt;/g'
}

# Flatten a markdown-ish assistant message into one glanceable line.
flatten() {
	printf '%s\n' "$1" |
		awk '/^[[:space:]]*```/ { fence = !fence; next } !fence' |
		sed -e 's/^[[:space:]]*#\+[[:space:]]*//' \
		    -e 's/^[[:space:]]*[-*][[:space:]]\+/ /' \
		    -e 's/`//g' -e 's/\*\*//g' |
		tr '\n' ' ' | tr -s '[:space:]' ' ' |
		sed -e 's/^ //' -e 's/ $//'
}

# Drop the live status glyph Claude prepends to the terminal title.
strip_glyph() {
	sed -e 's/^[^[:alnum:]]\+[[:space:]]*//' -e 's/[[:space:]]*$//'
}

clip() {
	local s=$1 n=$2
	[ "${#s}" -le "$n" ] && { printf '%s' "$s"; return; }
	s=${s:0:n}
	printf '%s…' "${s% *}"
}

# Focus the terminal window and Zellij pane this session lives in. Zellij titles
# the terminal "<session> | <focused pane>", which is the only link back from a
# pane to its sway container -- the panes hang off the Zellij server, not off the
# terminal, so process ancestry cannot find it.
focus_session() {
	[ -n "${ZELLIJ_SESSION_NAME:-}" ] || return 0
	local con
	if command -v swaymsg >/dev/null 2>&1; then
		con=$(swaymsg -t get_tree 2>/dev/null |
			jq -r --arg s "$ZELLIJ_SESSION_NAME" '
				first(recurse(.nodes[]?, .floating_nodes[]?)
				      | select((.name // "") | startswith($s + " | "))
				      | .id) // empty' 2>/dev/null)
		[ -n "${con:-}" ] && swaymsg "[con_id=$con] focus" >/dev/null 2>&1
	fi
	[ -n "${ZELLIJ_PANE_ID:-}" ] &&
		zellij -s "$ZELLIJ_SESSION_NAME" action focus-pane-id "$ZELLIJ_PANE_ID" >/dev/null 2>&1
	return 0
}

deliver() {
	local panes="" title="" focused body

	if [ -n "${ZELLIJ_SESSION_NAME:-}" ] && command -v zellij >/dev/null 2>&1; then
		panes=$(zellij -s "$ZELLIJ_SESSION_NAME" action list-panes -s -j 2>/dev/null)
	fi

	# Second body line: what this session is about. The Zellij pane title is
	# the session title with a live status glyph glued to the front.
	if [ -n "$panes" ]; then
		title=$(printf '%s' "$panes" | jq -r --arg p "${ZELLIJ_PANE_ID:-}" '
			first(.[] | select((.id | tostring) == $p and (.is_plugin | not)) | .title) // ""
		   ' 2>/dev/null | strip_glyph)
	fi
	if [ -z "$title" ] && [ -r "${CN_TRANSCRIPT:-/dev/null}" ]; then
		title=$(tail -n 20 "$CN_TRANSCRIPT" 2>/dev/null |
			jq -r 'select(.slug) | .slug' 2>/dev/null | tail -n 1)
	fi

	# Already looking at it? Then a "done" ding is just noise. Anything that
	# needs an answer still fires, focused or not.
	#
	# Zellij's own is_focused is true for more than one pane in a split layout,
	# so it cannot say which pane you are actually looking at. The terminal
	# title can: Zellij sets it to "<session> | <focused pane title>", so if it
	# names our pane, our pane is on screen and in front.
	if [ "${CN_SUPPRESS:-0}" = 1 ] && [ -n "$title" ] && command -v swaymsg >/dev/null 2>&1; then
		focused=$(swaymsg -t get_tree 2>/dev/null |
			jq -r --arg s "$ZELLIJ_SESSION_NAME" '
				first(recurse(.nodes[]?, .floating_nodes[]?)
				      | select(.focused == true)
				      | .name // "")
				| select(startswith($s + " | "))
				| ltrimstr($s + " | ") // empty' 2>/dev/null | strip_glyph)
		[ -n "$focused" ] && [ "$focused" = "$title" ] && return 0
	fi

	body=$(esc "$(clip "$(flatten "$CN_BODY")" 160)")
	if [ -n "$title" ]; then
		title="<span alpha='55%'>$(esc "$title")</span>"
		body=${body:+$body$'\n'}$title
	fi

	[ -r "$SOUND_DIR/$CN_SOUND.oga" ] && (paplay "$SOUND_DIR/$CN_SOUND.oga" >/dev/null 2>&1 &)

	# --action implies --wait, so this blocks until the card is clicked,
	# replaced or expires; that is the whole point of running detached.
	local action
	action=$(notify-send \
		--app-name=claude \
		--urgency="$CN_URGENCY" \
		--category="$CN_CATEGORY" \
		--hint="string:x-canonical-private-synchronous:$CN_TAG" \
		--hint="string:desktop-entry:claude" \
		--action="default=Focus" \
		"$CN_SUMMARY" "$body" 2>/dev/null)
	[ "$action" = default ] && focus_session
	return 0
}

if [ "${1:-}" = --deliver ]; then
	deliver
	exit 0
fi

# --- stage 1: parse and dispatch --------------------------------------------

EVENT= NTYPE= SESSION= CWD= MSG= LAST= TRANSCRIPT= AGENT=
eval "$(jq -r '
	@sh "EVENT=\(.hook_event_name // "")",
	@sh "NTYPE=\(.notification_type // "")",
	@sh "SESSION=\(.session_id // "")",
	@sh "CWD=\(.cwd // "")",
	@sh "MSG=\(.message // "")",
	@sh "LAST=\(.last_assistant_message // "")",
	@sh "TRANSCRIPT=\(.transcript_path // "")",
	@sh "AGENT=\(.agent_id // "")"
' 2>/dev/null)"

[ -n "$EVENT" ] || exit 0

# agent_id is set only when the hook fires from inside a subagent. Their turns
# start and stop constantly; only the main session is worth a popup.
[ -z "$AGENT" ] || exit 0

# The turn clock. Written here, read back and cleared by Stop.
STAMP="$STATE_DIR/${SESSION:-unknown}.start"

if [ "$EVENT" = UserPromptSubmit ]; then
	# 0700 whatever the caller's umask, and never write into a directory
	# somebody else got to first. A missing stamp only costs the duration
	# readout, so failing here is silent.
	(umask 077 && mkdir -p "$STATE_DIR") >/dev/null 2>&1
	[ -O "$STATE_DIR" ] || exit 0
	printf '%s' "$EPOCHSECONDS" >"$STAMP" 2>/dev/null
	exit 0
fi

PROJECT=$(basename "${CWD:-}" 2>/dev/null)
SUPPRESS=0
DUR=

case "$EVENT" in
Notification)
	case "$NTYPE" in
	permission_prompt | worker_permission_prompt)
		GLYPH=⚠ STATE=Permission CATEGORY=x-claude.input URGENCY=critical SOUND=message-new-instant ;;
	idle_prompt)
		GLYPH=◔ STATE=Idle CATEGORY=x-claude.idle URGENCY=critical SOUND=message ;;
	agent_needs_input)
		GLYPH=▶ STATE="Agent needs you" CATEGORY=x-claude.agent URGENCY=critical SOUND=message ;;
	elicitation_dialog | elicitation_url_dialog)
		GLYPH=◈ STATE=MCP CATEGORY=x-claude.input URGENCY=critical SOUND=message ;;
	*)
		# Everything else is a background-agent lifecycle event or a
		# non-event: agent_completed, auth_success, push_notification,
		# computer_use_*. Only the main session gets a card.
		exit 0 ;;
	esac
	BODY=$MSG
	;;
Stop)
	GLYPH=✓ STATE=Done CATEGORY=x-claude.done URGENCY=normal SOUND=device-added SUPPRESS=1
	BODY=$LAST
	if [ -O "$STATE_DIR" ] && [ -r "$STAMP" ]; then
		START=$(cat "$STAMP" 2>/dev/null)
		rm -f "$STAMP" 2>/dev/null
		if [ -n "${START:-}" ] && [ "$START" -gt 0 ] 2>/dev/null; then
			S=$((EPOCHSECONDS - START))
			if [ "$S" -ge 1 ] && [ "$S" -lt 86400 ]; then
				if [ "$S" -lt 60 ]; then DUR=$(printf '%ds' "$S")
				elif [ "$S" -lt 3600 ]; then DUR=$(printf '%dm%02ds' $((S / 60)) $((S % 60)))
				else DUR=$(printf '%dh%02dm' $((S / 3600)) $((S % 3600 / 60)))
				fi
			fi
		fi
	fi
	# Sweep stamps from sessions that ended without a Stop. Same ownership
	# rule: never -delete inside a directory that is not ours.
	[ -O "$STATE_DIR" ] &&
		find "$STATE_DIR" -maxdepth 1 -type f -name '*.start' -mmin +1440 -delete >/dev/null 2>&1
	;;
*)
	exit 0 ;;
esac

CN_SUMMARY="$GLYPH $STATE${PROJECT:+ · $PROJECT}${DUR:+ · $DUR}"
export CN_SUMMARY
export CN_BODY="$BODY"
export CN_CATEGORY="$CATEGORY"
export CN_URGENCY="$URGENCY"
export CN_SOUND="$SOUND"
export CN_SUPPRESS="$SUPPRESS"
export CN_TRANSCRIPT="$TRANSCRIPT"
export CN_TAG="claude-${SESSION:-unknown}"

# Absolute path: $0 is whatever the caller typed, and setsid does not inherit
# our cwd search.
SELF="$(cd -- "$(dirname -- "$0")" && pwd)/$(basename -- "$0")"
setsid --fork bash "$SELF" --deliver >/dev/null 2>&1 </dev/null
exit 0
