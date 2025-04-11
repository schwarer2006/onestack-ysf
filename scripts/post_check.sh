#!/bin/bash
# ==========================================================
# 📄 Script: post_check.sh
# 🧠 Zweck : Prüft nach dem Setup, ob alle Kernkomponenten korrekt installiert wurden
# 🔧 Version: 0.1.0
# ✏️ Status : stable
# 📅 Erstellt: 2025-04-10
# ==========================================================

set -e

ROOT_DIR="/opt/onestack-ysf"
LOG_FILE="$ROOT_DIR/logs/post_check.log"
PROJECT_SAMPLE="prj-0001"

echo "🔍 Starte Post-Check für OneStack YSF..." | tee "$LOG_FILE"

# === 1. Verzeichnisse prüfen ===
REQUIRED_DIRS=(
  "$ROOT_DIR/core"
  "$ROOT_DIR/scripts"
  "$ROOT_DIR/projects"
  "$ROOT_DIR/projects/$PROJECT_SAMPLE"
  "$ROOT_DIR/logs"
)

for dir in "${REQUIRED_DIRS[@]}"; do
  if [ -d "$dir" ]; then
    echo "✅ Verzeichnis vorhanden: $dir" | tee -a "$LOG_FILE"
  else
    echo "❌ FEHLT: $dir" | tee -a "$LOG_FILE"
  fi
done

# === 2. Beispielprojektstruktur prüfen ===
EXPECTED_SUBFOLDERS=("config" "nodes" "orchestration" "logs")
for sub in "${EXPECTED_SUBFOLDERS[@]}"; do
  path="$ROOT_DIR/projects/$PROJECT_SAMPLE/$sub"
  if [ -d "$path" ]; then
    echo "✅ Projektstruktur OK: $sub" | tee -a "$LOG_FILE"
  else
    echo "❌ Projektstruktur fehlt: $sub" | tee -a "$LOG_FILE"
  fi
done

# === 3. Python-Umgebung & Packages ===
echo "🐍 Python-Check..." | tee -a "$LOG_FILE"
if command -v python3 &> /dev/null; then
  echo "✅ Python verfügbar: $(python3 --version)" | tee -a "$LOG_FILE"
else
  echo "❌ Python3 fehlt!" | tee -a "$LOG_FILE"
fi

echo "📦 Prüfe wichtige Python-Packages..." | tee -a "$LOG_FILE"
REQUIRED_PKGS=("pyyaml" "pandas" "pyarrow" "duckdb" "fsspec")
for pkg in "${REQUIRED_PKGS[@]}"; do
  if python3 -c "import $pkg" &> /dev/null; then
    echo "✅ $pkg installiert" | tee -a "$LOG_FILE"
  else
    echo "❌ $pkg NICHT installiert!" | tee -a "$LOG_FILE"
  fi
done

# === 4. YAML-Testdateien vorhanden? ===
YAML_FILES=$(find "$ROOT_DIR/projects/$PROJECT_SAMPLE/nodes" -name "*.yaml")
if [ -n "$YAML_FILES" ]; then
  echo "✅ YAML-Dateien im Projekt gefunden:" | tee -a "$LOG_FILE"
  echo "$YAML_FILES" | tee -a "$LOG_FILE"
else
  echo "❌ Keine YAML-Dateien gefunden!" | tee -a "$LOG_FILE"
fi

# === 5. Schreibrechte prüfen ===
TEST_FILE="$ROOT_DIR/logs/postcheck_testfile.txt"
touch "$TEST_FILE" && echo "✅ Schreibtest erfolgreich: $TEST_FILE" | tee -a "$LOG_FILE"
rm -f "$TEST_FILE"

# === Abschluss ===
echo "✅ Post-Check abgeschlossen: $LOG_FILE"
