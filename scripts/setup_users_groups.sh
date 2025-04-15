#!/bin/bash
# ==========================================================
# 📄 Script: setup_users_groups.sh
# 🧠 Zweck : Erstellt Systemuser + Gruppen + Rechte für OneStack-Projekte
# 🔧 Version: 0.1.0
# ✏️ Status : stable
# 📅 Erstellt: 2025-04-11
# ==========================================================

set -e

GROUP_NAME=$1
DEV_USER=$2
SHARED_DIR="/data/shared"
YSF_ROOT="/opt/onestack-ysf"
SYS_USER="onestack"

if [[ -z "$GROUP_NAME" || -z "$DEV_USER" ]]; then
  echo "Usage: $0 <group-name> <dev-user>"
  echo "Beispiel: ./setup_users_groups.sh grp_customer erik2006"
  exit 1
fi

# 1. Systemuser onestack
if ! id "$SYS_USER" &>/dev/null; then
  echo "👤 Erstelle Systembenutzer: $SYS_USER"
  useradd -r -s /bin/bash -m "$SYS_USER"
fi

# 2. Gruppe anlegen (wenn nicht vorhanden)
if ! getent group "$GROUP_NAME" > /dev/null; then
  echo "👥 Erstelle Gruppe: $GROUP_NAME"
  groupadd "$GROUP_NAME"
fi

# 3. Entwickler zur Gruppe hinzufügen
usermod -aG "$GROUP_NAME" "$DEV_USER"
usermod -aG "$GROUP_NAME" "$SYS_USER"

echo "✅ Benutzer $DEV_USER und $SYS_USER zur Gruppe $GROUP_NAME hinzugefügt."

# 4. Berechtigungen für YSF & Shared-Ordner
echo "🔐 Setze Berechtigungen für $YSF_ROOT und $SHARED_DIR"
chgrp -R "$GROUP_NAME" "$YSF_ROOT" "$SHARED_DIR"
chmod -R 2770 "$YSF_ROOT" "$SHARED_DIR"  # SGID → vererbt Gruppe
find "$YSF_ROOT" "$SHARED_DIR" -type d -exec chmod g+s {} +

echo "✅ Gruppen, User und Rechte erfolgreich eingerichtet."
