#!/bin/bash
# ==========================================================
# 🛠️ Script: fix_permissions.sh
# 🧠 Zweck : Setzt die richtigen Berechtigungen für OneStack
# 🔧 Version: 0.1.0
# ✏️ Status : stable
# 📅 Erstellt: 2025-04-12
# ==========================================================

TARGET_DIR="/opt/onestack-ysf"
USER="onestack"
GROUP="onestack"

echo "🔍 Überprüfe Berechtigungen unter: $TARGET_DIR"
echo "👤 Ziel-Benutzer: $USER"
echo "👥 Ziel-Gruppe  : $GROUP"

read -p "⚠️  Fortfahren und alle Berechtigungen neu setzen? [y/N] " confirm

if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
  sudo chown -R "$USER:$GROUP" "$TARGET_DIR"
  sudo chmod -R ug+rwX,o-rwx "$TARGET_DIR"

  echo "✅ Berechtigungen erfolgreich gesetzt."
else
  echo "❌ Abgebrochen."
fi
