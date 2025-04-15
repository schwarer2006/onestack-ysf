#!/bin/bash
# ==========================================================
# 🐚 OneStack Dev Shell
# 🧠 Zweck : Gekapselte Shell mit OneStack-Umgebung
# 🔧 Version: 0.1.0
# ✏️ Status : stable
# 📅 Erstellt: 2025-04-13
# ==========================================================

echo "🚀 Starte OneStack-Entwicklungsumgebung..."

# Virtuelle Umgebung aktivieren
source ~/venv/onestack/bin/activate

# Arbeitsverzeichnis setzen
cd /opt/onestack-ysf || exit

# Custom Prompt
export PS1="\[\033[1;34m\](onestack-shell) \[\033[0m\]\w\$ "

# Rollen-Umgebung laden
export ONESTACK_ROLE=dev

# Pfade setzen (z. B. für core access)
export ONESTACK_ROOT=/opt/onestack-ysf
export ONESTACK_WORKSPACE=/opt/onestack-ysf/workspace
export ONESTACK_DATAPOOL=/opt/onestack-ysf/datapool

# Starte subshell
bash --noprofile --norc
