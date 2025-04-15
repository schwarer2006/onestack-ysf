#!/bin/bash
# ==============================================================================
# 📄 Script: init_project_env.sh
# 🧠 Zweck : Initialisiert neues OneStack-Projekt mit erstem Node & Struktur
# 🔐 Sicherheit: Nur mit aktiver Secure Shell erlaubt
# 🔧 Version : 1.1.0
# ✏️ Status  : stable
# 📅 Erstellt: 2025-04-12
# ==============================================================================

source /opt/onestack-ysf/core/security/session_guard.sh
require_secure_shell

# ------------------------------------------------------
# 🧩 Parameter
# ------------------------------------------------------
PROJECT_ID="$1"
GROUP="$2"
NODE_ID="node-0001"

if [ -z "$PROJECT_ID" ]; then
  echo "❌ Bitte gib eine Projekt-ID an (z. B. prj-0003)"
  echo "🔧 Beispiel: bash scripts/init_project_env.sh prj-0003 grp_customer"
  exit 1
fi

GROUP=${GROUP:-onestack}

# ------------------------------------------------------
# 🗂️ Verzeichnisse
# ------------------------------------------------------
WORKSPACE_BASE="/opt/onestack-ysf/workspace/projects/$PROJECT_ID"
DATAPOOL_NODE="/opt/onestack-ysf/datapool/projects/$PROJECT_ID/$NODE_ID"
NODE_CONFIG_PATH="$WORKSPACE_BASE/nodes/$NODE_ID/config"

# ------------------------------------------------------
# 📁 Verzeichnisse anlegen
# ------------------------------------------------------
echo "🚀 Initialisiere Projekt: $PROJECT_ID"
mkdir -p "$WORKSPACE_BASE"/{config,nodes,tests,logs}
mkdir -p "$NODE_CONFIG_PATH"
mkdir -p "$DATAPOOL_NODE"/{in,out,logs,meta}

# ------------------------------------------------------
# 🧾 YAML-Template für node-0001
# ------------------------------------------------------
cat <<EOF > "$NODE_CONFIG_PATH/${NODE_ID}_loader.yaml"
# ==============================================================================
# 📄 Node: $NODE_ID
# 🔧 Typ: loader
# 🧠 Zweck: Erstes Beispiel-Node-Template für Projekt $PROJECT_ID
# ==============================================================================
type: source
name: example_loader
source_file: /data/shared/example.csv
load_type: csv
created_by: $USER
created_at: $(date -Iseconds)
project: $PROJECT_ID
node: $NODE_ID
EOF

# ------------------------------------------------------
# 🔒 Rechte & Eigentümer
# ------------------------------------------------------

if ! getent group "$GROUP" > /dev/null; then
  echo "⚠️  Gruppe '$GROUP' existiert nicht. Lege sie an..."
  groupadd "$GROUP"
  echo "✅ Gruppe '$GROUP' wurde angelegt."
fi

chown -R onestack:$GROUP "$WORKSPACE_BASE" "$DATAPOOL_NODE"
chmod -R 770 "$WORKSPACE_BASE" "$DATAPOOL_NODE"

# ------------------------------------------------------
# ✅ Abschluss
# ------------------------------------------------------
echo "✅ Projekt $PROJECT_ID mit Node $NODE_ID erfolgreich eingerichtet."
echo "📁 Workspace : $WORKSPACE_BASE"
echo "📁 Datapool  : $DATAPOOL_NODE"
