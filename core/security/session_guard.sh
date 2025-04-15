#!/bin/bash
# ===================================================================
# 📄 Script: session_guard.sh
# 🧠 Zweck : Verhindert Account-Sharing & trackt aktive Sessions
# 🔐 Status: stable
# 🔧 Version: 1.0.0
# 📅 Erstellt: 2025-04-12
# ===================================================================

USER_ID="$USER"
SESSION_FILE="/tmp/.onestack_session_${USER_ID}.lock"
AUDIT_LOG="/opt/onestack-ysf/logs/session_audit.log"
CURRENT_TTY=$(tty)

# 🧠 1. Prüfen ob Session bereits aktiv ist
if [[ -f "$SESSION_FILE" ]]; then
  EXISTING_TTY=$(cut -d '|' -f2 "$SESSION_FILE")
  if [[ "$EXISTING_TTY" != "$CURRENT_TTY" ]]; then
    echo "⛔ Session-Konflikt: $USER_ID ist bereits auf $EXISTING_TTY aktiv."
    echo "$(date '+%Y-%m-%d %H:%M:%S') | SHARING-DETECTED | $USER_ID | $CURRENT_TTY | Konflikt mit $EXISTING_TTY" >> "$AUDIT_LOG"
    exit 1
  fi
fi

# 🔐 2. Session schreiben (flüchtig)
SESSION_ID=$(uuidgen)
echo "$SESSION_ID|$CURRENT_TTY|$(date '+%Y-%m-%d %H:%M:%S')" > "$SESSION_FILE"
export ONESTACK_SESSION_ID="$SESSION_ID"

# 📜 3. Logging
echo "$(date '+%Y-%m-%d %H:%M:%S') | LOGIN | $USER_ID | $CURRENT_TTY | Session: $SESSION_ID" >> "$AUDIT_LOG"
