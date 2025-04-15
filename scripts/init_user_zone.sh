#!/bin/bash
# ==========================================================
# 🧰 Script: init_user_zone.sh
# 🧠 Zweck: Erstellt Benutzerarbeitsbereich innerhalb von OneStack
# 👤 Autor: onestack-dev
# 🔧 Version: 0.1.0
# 📅 Erstellt: 2025-04-12
# ✏️ Status: stable
# ==========================================================

USERNAME=$(whoami)
USER_DIR="/opt/onestack-ysf/.user_data/$USERNAME"

echo "🔐 Initialisiere Benutzerzone für: $USERNAME"
echo "📁 Ziel: $USER_DIR"

mkdir -p "$USER_DIR/yaml_repos/personal_lookups"
mkdir -p "$USER_DIR/yaml_repos/custom_templates"
mkdir -p "$USER_DIR/scripts"
mkdir -p "$USER_DIR/logs"

# Standarddateien anlegen
touch "$USER_DIR/bookmarks.yaml"
touch "$USER_DIR/preferences.yaml"
touch "$USER_DIR/recent.yaml"

# Beispielinhalte einfügen (nur falls leer)
if [ ! -s "$USER_DIR/preferences.yaml" ]; then
cat <<EOF > "$USER_DIR/preferences.yaml"
editor: nano
theme: dark
default_project: prj-0001
EOF
fi

echo "✅ Benutzerzone erfolgreich erstellt unter: $USER_DIR"
echo "🧭 Schnellzugriffe: bookmarks.yaml, preferences.yaml, recent.yaml"
