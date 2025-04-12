#!/bin/bash
# ==========================================================
# 📄 Script: init_workspace_root.sh
# 🧠 Zweck : Erstellt und konfiguriert das /data/workspace Root-Verzeichnis
# 🔧 Version: 0.1.0
# ✏️ Status : stable
# ==========================================================

WORKSPACE_ROOT="/data/workspace"
GROUP_NAME="onestackdev"
OWNER="onestack"

echo "🚀 Initialisiere Workspace Root unter: $WORKSPACE_ROOT"

# Verzeichnis anlegen, falls nicht vorhanden
if [ ! -d "$WORKSPACE_ROOT" ]; then
    sudo mkdir -p "$WORKSPACE_ROOT"
    echo "📁 Verzeichnis erstellt: $WORKSPACE_ROOT"
fi

# Besitzer und Gruppe setzen
sudo chown $OWNER:$GROUP_NAME "$WORKSPACE_ROOT"
echo "👤 Besitzer gesetzt: $OWNER"
echo "👥 Gruppe gesetzt  : $GROUP_NAME"

# Rechte setzen (rwx für Owner + Group, nichts für andere)
sudo chmod 770 "$WORKSPACE_ROOT"
echo "🔐 Rechte gesetzt: 770 (rwxrwx---)"

# Set-GID Bit setzen, damit Unterverzeichnisse automatisch die Gruppe übernehmen
sudo chmod g+s "$WORKSPACE_ROOT"
echo "🔁 Set-GID Bit gesetzt für automatische Gruppenerben"

echo "✅ Root Workspace ist nun bereit: $WORKSPACE_ROOT"
