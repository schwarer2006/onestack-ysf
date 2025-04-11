#!/bin/bash
# ==========================================================
# 📄 Script: setup.sh
# 🧠 Zweck : Führt das komplette Setup von OneStack YSF aus
# 🔧 Version: 0.1.0
# ✏️ Status : stable
# 📅 Erstellt: 2025-04-10
# ==========================================================

set -e

# === Pfade ===
ROOT_DIR="/opt/onestack-ysf"
SCRIPT_DIR="$ROOT_DIR/scripts"
LOG_FILE="$ROOT_DIR/logs/setup.log"

echo "🚀 Starte OneStack YSF Setup..."
echo "🕒 $(date)" > "$LOG_FILE"

# === 1. Preflight Check ===
if [ -f "$SCRIPT_DIR/preflight_check.sh" ]; then
  echo "🔍 Führe Preflight Check aus..." | tee -a "$LOG_FILE"
  bash "$SCRIPT_DIR/preflight_check.sh" >> "$LOG_FILE" 2>&1
else
  echo "⚠️ Kein preflight_check.sh gefunden." | tee -a "$LOG_FILE"
fi

# === 2. Core-Installation ===
if [ -f "$SCRIPT_DIR/install.sh" ]; then
  echo "📦 Installiere Core-Komponenten..." | tee -a "$LOG_FILE"
  bash "$SCRIPT_DIR/install.sh" >> "$LOG_FILE" 2>&1
else
  echo "⚠️ Kein install.sh gefunden." | tee -a "$LOG_FILE"
fi

# === 3. Beispielprojekt anlegen (optional) ===
if [ -f "$SCRIPT_DIR/bootstrap.sh" ]; then
  echo "🧱 Lege Beispielprojekt prj-0001 an..." | tee -a "$LOG_FILE"
  bash "$SCRIPT_DIR/bootstrap.sh" --project prj-0001 --group onestack --with-tests >> "$LOG_FILE" 2>&1
else
  echo "⚠️ Kein bootstrap.sh gefunden." | tee -a "$LOG_FILE"
fi

# === 4. (Optional) Python Requirements ===
REQ="$ROOT_DIR/requirements.txt"
if [ -f "$REQ" ]; then
  echo "📦 Installiere Python-Abhängigkeiten..." | tee -a "$LOG_FILE"
  pip install -r "$REQ" >> "$LOG_FILE" 2>&1
fi

echo "✅ OneStack YSF Setup abgeschlossen!"
echo "📄 Siehe Log: $LOG_FILE"
 
