#!/usr/bin/env bash
# ==========================================================
# 📄 Script: auto_loaders_from_shared.sh
# 🧠 Zweck : Automatische Erstellung von Nodes, Loader-YAMLs,
#            und Verzeichnisstruktur aus CSVs in /data/shared
# 🔧 Version: 0.1.0
# ✏️ Status : initial
# 📅 Erstellt: 2025-04-12
# ==========================================================

set -e

PROJECT_ID=$1
GROUP=$2

if [[ -z "$PROJECT_ID" || -z "$GROUP" ]]; then
  echo "❌ Aufruf: $0 <project-id> <group>"
  exit 1
fi

SHARED_DIR="/data/shared"
WORKSPACE_ROOT="/opt/onestack-ysf/workspace/projects/$PROJECT_ID"
DATAPOOL_ROOT="/opt/onestack-ysf/datapool/projects/$PROJECT_ID"

mkdir -p "$WORKSPACE_ROOT/nodes"
mkdir -p "$DATAPOOL_ROOT"

echo "🔎 Durchsuche $SHARED_DIR nach CSV-Dateien..."
i=1
for file in "$SHARED_DIR"/*.csv; do
  [[ -e "$file" ]] || continue
  filename=$(basename -- "$file")
  name="${filename%.*}"

  node_id=$(printf "node-%04d" "$i")
  node_workspace="$WORKSPACE_ROOT/nodes/$node_id"
  node_datapool="$DATAPOOL_ROOT/$node_id"

  echo "📦 Erstelle Node: $node_id für $filename"

  # Erstelle Verzeichnisse
  mkdir -p "$node_workspace/config"
  mkdir -p "$node_workspace/tests"
  mkdir -p "$node_workspace/logs"
  mkdir -p "$node_workspace/meta"

  mkdir -p "$node_datapool/in"
  mkdir -p "$node_datapool/out"

  # YAML erstellen
  yaml_path="$node_workspace/config/${name}_loader.yaml"
  cat > "$yaml_path" <<EOF
# ==========================================================
# 🧾 Loader YAML: ${name}_loader.yaml
# 🌱 Erstellt durch Auto-Loader
# ==========================================================
type: source
name: ${name}_loader
source_file: $SHARED_DIR/$filename
load_type: csv
project: $PROJECT_ID
node: $node_id
created_by: $(whoami)
created_at: $(date -Iseconds)
EOF

  # Rechte setzen
  chown -R onestack:"$GROUP" "$node_workspace"
  chown -R onestack:"$GROUP" "$node_datapool"
  chmod -R 770 "$node_workspace" "$node_datapool"

  ((i++))
done

echo "✅ Alle Loader & Verzeichnisse wurden erstellt für Projekt: $PROJECT_ID"
