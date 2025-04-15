#!/bin/bash
# ==========================================================
# 🧹 Script: audit_and_migrate_legacy_layout.sh
# 🧠 Zweck : Prüft veraltete Projektstrukturen (in/out in projects/)
#            und migriert sie nach /datapool/<projekt>/<node>/
# 🔧 Version: 0.1.0
# ✏️ Status : experimental
# 📅 Erstellt: 2025-04-13
# ==========================================================

set -e

PROJECT_DIR="projects"
DATAPOOL_DIR="/datapool"

echo "🔍 Starte Struktur-Audit im Projektverzeichnis '$PROJECT_DIR'..."

for NODE_DIR in $(find $PROJECT_DIR -type d -name "node-*"); do
    NODE_ID=$(basename "$NODE_DIR")
    PROJECT_ID=$(echo "$NODE_DIR" | cut -d'/' -f2)

    echo "📦 Prüfe $NODE_DIR"

    for SUB in in out; do
        OLD_PATH="$NODE_DIR/$SUB"
        NEW_PATH="$DATAPOOL_DIR/$PROJECT_ID/$NODE_ID/$SUB"

        if [ -d "$OLD_PATH" ]; then
            echo "⚠️  Legacy-Verzeichnis gefunden: $OLD_PATH"
            echo "   👉 Neuer Zielpfad: $NEW_PATH"

            read -p "❓ Möchtest du '$OLD_PATH' nach '$NEW_PATH' verschieben? (y/n) " confirm
            if [[ "$confirm" == "y" ]]; then
                mkdir -p "$NEW_PATH"
                mv "$OLD_PATH"/* "$NEW_PATH"/ 2>/dev/null || true
                rm -r "$OLD_PATH"
                echo "✅ Verschoben und bereinigt."
            else
                echo "⏩ Übersprungen."
            fi
        fi
    done
done

echo "✅ Audit abgeschlossen."
