#!/bin/bash
# ==========================================================
# 🔐 Script: check_permissions.sh
# 🧠 Zweck : Prüft Besitzer & Rechte innerhalb von OneStack
# 📂 Bereich: /opt/onestack-ysf (ohne venv/)
# 🔧 Version: 1.1.0
# ✏️ Status : stable
# ==========================================================

ROOT_DIR="/opt/onestack-ysf"
EXPECTED_USER="onestack"
EXPECTED_GROUP="onestack"
EXPECTED_PERMS="770"
FIX_MODE=false

# --- Farben ---
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
RESET='\033[0m'

# --- Optionen prüfen ---
if [[ "$1" == "--fix" ]]; then
  FIX_MODE=true
fi

echo "🔍 Starte Prüfung in: $ROOT_DIR"
echo "👤 Erwarteter User : $EXPECTED_USER"
echo "👥 Erwartete Gruppe: $EXPECTED_GROUP"
echo "🔐 Erwartete Rechte: $EXPECTED_PERMS"
echo ""

COUNT_TOTAL=0
COUNT_FIX=0
COUNT_SKIP=0

# --- Prüfung ---
while IFS= read -r -d '' file; do
  ((COUNT_TOTAL++))

  # venv ausschließen
  if [[ "$file" == *"/venv/"* ]]; then
    ((COUNT_SKIP++))
    continue
  fi

  current_user=$(stat -c '%U' "$file")
  current_group=$(stat -c '%G' "$file")
  current_perms=$(stat -c '%a' "$file")

  if [[ "$current_user" != "$EXPECTED_USER" || "$current_group" != "$EXPECTED_GROUP" || "$current_perms" != "$EXPECTED_PERMS" ]]; then
    echo -e "⚠️  Abweichung: ${file}"
    echo -e "   👤 ${current_user}:${current_group} (${current_perms}) → erwartet: ${EXPECTED_USER}:${EXPECTED_GROUP} (${EXPECTED_PERMS})"

    if $FIX_MODE; then
      chown "$EXPECTED_USER:$EXPECTED_GROUP" "$file"
      chmod "$EXPECTED_PERMS" "$file"
      echo -e "   ✅ ${GREEN}Korrigiert${RESET}"
      ((COUNT_FIX++))
    fi
  fi

done < <(find "$ROOT_DIR" -type f -print0)

# --- Ergebnis ---
echo ""
echo "📊 Zusammenfassung:"
echo "   🔍 Geprüft     : $COUNT_TOTAL Dateien"
echo "   🚫 Übersprungen: $COUNT_SKIP (venv/)"
echo "   🔧 Korrigiert  : $COUNT_FIX"
echo "   ❌ Fehler      : 0"
