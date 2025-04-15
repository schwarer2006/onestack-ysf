#!/bin/bash
# ==========================================================
# 🖥️ Script: onestack_loader_menu.sh
# 🎛️ Zweck: Terminal-Menü für den YSF Loader
# 🔧 Version: 0.1.0
# ✏️ Status: draft
# 📅 Erstellt: 2025-04-13
# ==========================================================

while true; do
    CHOICE=$(whiptail --title "OneStack Loader" --menu "Aktion wählen:" 20 60 10 \
    "1" "CSV → YAML-Konfiguration erzeugen" \
    "2" "YAML-Konfiguration anzeigen" \
    "3" "Ladeprozess starten (CSV → Parquet)" \
    "4" "Peek Parquet-Datei" \
    "5" "Beenden" 3>&1 1>&2 2>&3)

    case $CHOICE in
        1)
            CSV_FILE=$(whiptail --inputbox "Pfad zur CSV-Datei:" 10 60 "/data/shared/" 3>&1 1>&2 2>&3)
            PROJECT_ID=$(whiptail --inputbox "Projekt-ID:" 10 40 "prj-0002" 3>&1 1>&2 2>&3)
            NODE_ID=$(whiptail --inputbox "Node-ID:" 10 40 "node-0001" 3>&1 1>&2 2>&3)
            LOADER_NAME=$(whiptail --inputbox "Name der Loader-Config:" 10 40 "my_loader" 3>&1 1>&2 2>&3)
            python3 tools/generate_yaml_from_csv.py \
              --csv "$CSV_FILE" \
              --output "workspace/projects/$PROJECT_ID/nodes/$NODE_ID" \
              --project "$PROJECT_ID" \
              --node "$NODE_ID" \
              --name "$LOADER_NAME"
            read -n 1 -s -r -p "✅ YAML erstellt. Weiter mit beliebiger Taste..."
            ;;
        2)
            YAML_FILE=$(find workspace/projects -name "*.yaml" | fzf)
            clear
            echo "📄 Anzeige von $YAML_FILE:"
            echo "--------------------------------------------"
            onestack view --file "$YAML_FILE" --type yaml
            read -n 1 -s -r -p "🔍 Weiter mit beliebiger Taste..."
            ;;
        3)
            YAML_FILE=$(find workspace/projects -name "*.yaml" | fzf)
            onestack load --file "$YAML_FILE"
            read -n 1 -s -r -p "📥 Weiter mit beliebiger Taste..."
            ;;
        4)
            PARQUET_FILE=$(find /opt/onestack-ysf/datapool -name "*.parquet" | fzf)
            onestack peek --file "$PARQUET_FILE" --rows 15 --meta
            read -n 1 -s -r -p "📊 Weiter mit beliebiger Taste..."
            ;;
        5)
            echo "👋 Bye!"
            exit 0
            ;;
    esac
done
