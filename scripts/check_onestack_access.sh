#!/bin/bash
# ================================================================
# 🛡️ Script: check_onestack_access.sh
# 🔍 Zweck : Prüft User-Gruppe & Zugriffsrechte auf /opt/onestack-ysf
# 🧪 Status: stable
# 📅 Erstellt: 2025-04-12
# ================================================================

ONESTACK_GROUP="onestack"
TARGET_DIR="/opt/onestack-ysf"
CURRENT_USER=$(whoami)

echo "🔍 Prüfe Gruppenmitgliedschaft für Benutzer: $CURRENT_USER"
if id -nG "$CURRENT_USER" | grep -qw "$ONESTACK_GROUP"; then
    echo "✅ $CURRENT_USER ist Mitglied der Gruppe '$ONESTACK_GROUP'"
else
    echo "⚠️  $CURRENT_USER ist NICHT Mitglied der Gruppe '$ONESTACK_GROUP'"
    read -p "➕ Soll $CURRENT_USER zur Gruppe '$ONESTACK_GROUP' hinzugefügt werden? (j/n): " ADDUSER
    if [[ "$ADDUSER" == "j" ]]; then
        sudo usermod -aG "$ONESTACK_GROUP" "$CURRENT_USER"
        echo "✅ Benutzer hinzugefügt. Bitte einmal ab- und wieder anmelden!"
        exit 0
    else
        echo "⛔ Zugriff kann ohne Gruppenmitgliedschaft eingeschränkt sein."
    fi
fi

echo "🔍 Prüfe Zugriffsrechte auf $TARGET_DIR..."
if [ -x "$TARGET_DIR" ]; then
    echo "✅ Zugriff auf $TARGET_DIR ist möglich."
else
    echo "❌ Zugriff verweigert für $CURRENT_USER auf $TARGET_DIR"
    read -p "🔧 Rechte automatisch korrigieren (Set Group Access + g+s)? (j/n): " FIXPERMS
    if [[ "$FIXPERMS" == "j" ]]; then
        sudo chown -R root:"$ONESTACK_GROUP" "$TARGET_DIR"
        sudo chmod -R g+rwX "$TARGET_DIR"
        sudo find "$TARGET_DIR" -type d -exec chmod g+s {} \;
        echo "✅ Zugriffsrechte wurden aktualisiert."
    else
        echo "ℹ️ Du kannst manuell mit sudo chown/chmod nachjustieren."
    fi
fi
