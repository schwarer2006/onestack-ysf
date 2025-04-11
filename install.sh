#!/bin/bash
# ==========================================================
# 📄 Script: install.sh
# 🧠 Zweck : Bereitet Verzeichnisse, Rechte und Config-DB für OneStack YSF vor
# 🔧 Version: 0.2.0
# 📅 Erstellt: 2025-04-10
# ==========================================================

set -e

BASE="/opt/onestack-ysf"
USER="onestack"
GROUP="onestack-devs"
CONFIG_DB="$BASE/storage/duckdb/system/onestack_meta.duckdb"
USE_CONFIG_DB=true

DIRS=(
  "$BASE/core/engine"
  "$BASE/core"
  "$BASE/projects"
  "$BASE/logs/core"
  "$BASE/shared"
  "$BASE/scripts"
  "$BASE/storage/duckdb/dev"
  "$BASE/storage/duckdb/qa"
  "$BASE/storage/duckdb/prod"
  "$BASE/storage/duckdb/system"
)

echo "🧰 OneStack YSF Installationsvorbereitung..."

for dir in "${DIRS[@]}"; do
  echo "📁 Erstelle: $dir"
  mkdir -p "$dir"
  chown -R "$USER:$GROUP" "$dir"
  chmod -R 775 "$dir"
done

touch "$BASE/logs/test_results.log"
chown "$USER:$GROUP" "$BASE/logs/test_results.log"
chmod 664 "$BASE/logs/test_results.log"

if [ "$USE_CONFIG_DB" = true ]; then
  echo "🧠 Erzeuge Konfigurationsdatenbank in DuckDB..."
  python3 - <<EOF
import duckdb
con = duckdb.connect("$CONFIG_DB")
con.execute(\"\"\"
CREATE TABLE IF NOT EXISTS projects (
    project_id TEXT PRIMARY KEY,
    group_name TEXT,
    created_at TIMESTAMP,
    status TEXT,
    version TEXT
);
CREATE TABLE IF NOT EXISTS engine_modules (
    module TEXT,
    version TEXT,
    description TEXT
);
CREATE TABLE IF NOT EXISTS nodes (
    node_id TEXT,
    project_id TEXT,
    type TEXT,
    last_run TIMESTAMP
);
\"\"\")
con.close()
EOF
fi

echo "✅ Installation abgeschlossen. Basisstruktur ist bereit."
"""

bootstrap_sh_updated = """#!/bin/bash
# ==========================================================
# 📄 Script: bootstrap.sh
# 🧠 Zweck : Erstellt neues Projekt mit Verzeichnisstruktur & optionaler DuckDB-Registry
# 🔧 Version: 0.2.0
# 📅 Erstellt: 2025-04-10
# ==========================================================

set -e

PROJECT_NAME=""
GROUP_NAME=""
ROOT_PATH="/opt/onestack-ysf/projects"
TEMPLATE_SOURCE="/opt/onestack-ysf/core/templates"
USER_ONESTACK="onestack"
CREATE_TESTS=0
WRITE_TO_DUCKDB=true
CONFIG_DB="/opt/onestack-ysf/storage/duckdb/system/onestack_meta.duckdb"

print_usage() {
  echo "Usage: $0 --project prj-0001 --group grp_kunde1 [--with-tests]"
}

while [[ "$#" -gt 0 ]]; do
  case "$1" in
    --project)
      PROJECT_NAME="$2"
      shift 2
      ;;
    --group)
      GROUP_NAME="$2"
      shift 2
      ;;
    --with-tests)
      CREATE_TESTS=1
      shift 1
      ;;
    *)
      echo "Unknown parameter: $1"
      print_usage
      exit 1
      ;;
  esac
done

if [[ -z "$PROJECT_NAME" || -z "$GROUP_NAME" ]]; then
  echo "❌ Projektname und Gruppenname sind erforderlich."
  print_usage
  exit 1
fi

PROJECT_PATH="$ROOT_PATH/$PROJECT_NAME"
echo "🚀 Erstelle Projekt: $PROJECT_PATH"

mkdir -p "$PROJECT_PATH"/{config,nodes,orchestration,logs,templates}
chown -R "$USER_ONESTACK:$GROUP_NAME" "$PROJECT_PATH"
chmod -R 2770 "$PROJECT_PATH"

echo "# Projekt: $PROJECT_NAME" > "$PROJECT_PATH/README.md"
echo "Erstellt am: $(date)" >> "$PROJECT_PATH/README.md"
echo "Gruppe: $GROUP_NAME" >> "$PROJECT_PATH/README.md"

cp -r "$TEMPLATE_SOURCE/"* "$PROJECT_PATH/templates/" || echo "⚠️ Keine Templates gefunden."

if [[ $CREATE_TESTS -eq 1 ]]; then
  mkdir -p "$PROJECT_PATH/tests"
  echo "# Tests für $PROJECT_NAME" > "$PROJECT_PATH/tests/__init__.py"
  echo "🧪 Teststruktur angelegt."
fi

if [ "$WRITE_TO_DUCKDB" = true ]; then
  echo "🧠 Projekt in DuckDB-Konfigurationsdatenbank eintragen..."
  python3 - <<EOF
import duckdb
from datetime import datetime
con = duckdb.connect("$CONFIG_DB")
con.execute("INSERT INTO projects VALUES (?, ?, ?, ?, ?)",
    ("$PROJECT_NAME", "$GROUP_NAME", datetime.now(), "active", "0.1.0"))
con.close()
EOF
fi

echo "✅ Projekt $PROJECT_NAME wurde erfolgreich erstellt."
"""

# Speichere beide Dateien
install_path = "/mnt/data/install.sh"
bootstrap_path = "/mnt/data/bootstrap.sh"

with open(install_path, "w") as f:
    f.write(install_sh_updated)

with open(bootstrap_path, "w") as f:
    f.write(bootstrap_sh_updated)

install_path, bootstrap_path
