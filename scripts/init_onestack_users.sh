#!/bin/bash
# ==========================================================
# 📄 Script: init_onestack_users.sh
# 🧠 Zweck : Erstellt OneStack-User mit vordefinierten Rollen
# 🔧 Version: 0.1.0
# ✏️ Status : draft
# 📅 Erstellt: 2025-04-12
# ==========================================================

USERS=("admin2006" "dev2006" "readonly2006")
PASSWORD="ubuntu2006"
GROUP="onestack"

for USER in "${USERS[@]}"; do
  echo "🔧 Erstelle Benutzer: $USER"

  if id "$USER" &>/dev/null; then
    echo "⚠️  $USER existiert bereits – wird übersprungen."
  else
    sudo useradd -m -s /bin/bash "$USER"
    echo "$USER:$PASSWORD" | sudo chpasswd
    sudo usermod -aG "$GROUP" "$USER"

    echo "✅ Benutzer $USER angelegt und zur Gruppe $GROUP hinzugefügt."
  fi

  # venv-Aktivierung in .bashrc einfügen (einmalig)
  BASHRC="/home/$USER/.bashrc"
  VENV_LINE='source /home/'"$USER"'/venv/onestack/bin/activate'
  if ! grep -q "$VENV_LINE" "$BASHRC"; then
    echo "$VENV_LINE" | sudo tee -a "$BASHRC" > /dev/null
  fi

done

echo "🎉 Alle Benutzer wurden verarbeitet."
