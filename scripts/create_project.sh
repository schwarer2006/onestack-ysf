#!/bin/bash
# ==========================================================
# 📄 Script: create_project.sh
# 🧠 Zweck : Erstellt ein vollständiges Projekt inkl. Node & Rechte
# 🔧 Version: 0.1.0
# ✏️ Status : stable
# 📅 Erstellt: 2025-04-11
# ==========================================================

set -e

# === Variablen ===
PROJECT_ID=$1
GROUP_NAME=$2
ROOT_DIR="/opt/onestack-ysf/projects"
USER_ONESTACK="onestack"

# === Hilfe ===
if [[ -z "$PROJECT_ID" || -z "$GROUP_NAME" ]]; then
  echo "Usage: $0 <project-id> <group-name>"
  echo "Beispiel: ./create_project.sh prj-0001 grp_customer"
  exit 1
fi

PROJECT_PATH="$ROOT_DIR/$PROJECT_ID"

echo "🚀 Erstelle Projekt: $PROJECT_PATH"

# === Verzeichnisstruktur ===
mkdir -p "$PROJECT_PATH"/{config,nodes,node-templates,logs,orchestration,templates,tests}
mkdir -p "$PROJECT_PATH/nodes/node-0001"

# === Rechte setzen ===
chown -R "$USER_ONESTACK:$GROUP_NAME" "$PROJECT_PATH"
chmod -R 2770 "$PROJECT_PATH"

# === README + Basisdateien ===
echo "# 📦 Projekt: $PROJECT_ID" > "$PROJECT_PATH/README.md"
echo "Gruppe: $GROUP_NAME" >> "$PROJECT_PATH/README.md"
echo "Erstellt am: $(date)" >> "$PROJECT_PATH/README.md"

echo "✅ Projekt $PROJECT_ID wurde vollständig eingerichtet."
