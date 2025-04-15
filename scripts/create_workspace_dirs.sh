#!/bin/bash
# ==========================================================
# 📄 Script: create_workspace_dirs.sh
# 🧠 Zweck : Erstellt Datenverzeichnisse für ein Projekt/Node
# 🔧 Version: 0.1.0
# ✏️ Status : stable
# ==========================================================

# Nutzung: bash scripts/create_workspace_dirs.sh <projekt_id> <node_id> <gruppe>

PROJ=$1
NODE=$2
GRP=$3
BASE="/data/workspace"

if [[ -z "$PROJ" || -z "$NODE" || -z "$GRP" ]]; then
  echo "❌ Bitte Projekt-ID, Node-ID und Gruppe angeben!"
  echo "👉 Beispiel: bash scripts/create_workspace_dirs.sh prj-0002 node-0001 grp_customer"
  exit 1
fi

TARGET="$BASE/$PROJ/$NODE"

# Verzeichnisse erstellen
mkdir -p $TARGET/{in,out,gold,logs}

# Berechtigungen setzen
chown -R onestack:$GRP $BASE/$PROJ
chmod -R 770 $BASE/$PROJ

echo "✅ Workspace erstellt unter: $TARGET"
echo "👤 Besitzer: onestack"
echo "👥 Gruppe : $GRP"
echo "🔒 Rechte : rwx für owner und group"
