#!/bin/bash
# ==========================================================
# 📄 Script: onestack_menu.sh
# 🧠 Zweck : Interaktives Menü für OneStack CLI
# 🔧 Version: 0.2.0
# ✏️ Status : beta
# 📅 Erstellt: 2025-04-12
# ==========================================================

set -e

# Hilfsfunktion: kompakte Fehleranzeige
function show_error() {
  whiptail --title "❌ Fehler" --msgbox "$1" 10 60
}

# Hauptmenü anzeigen
function main_menu() {
  CHOICE=$(whiptail --title "OneStack-YSF 🧠 Hauptmenü" --menu "Was möchtest du tun?" 20 70 10 \
  "1" "📂 YAML & Daten anzeigen" \
  "2" "📥 CSV → Parquet laden" \
  "3" "✅ Validierung & Test" \
  "4" "🔧 Admin & System" \
  "5" "🚪 Beenden" 3>&1 1>&2 2>&3)

  case $CHOICE in
    1) view_menu ;;
    2) load_csv ;;
    3) validation_menu ;;
    4) admin_menu ;;
    5) exit 0 ;;
    *) show_error "Ungültige Auswahl";;
  esac
}

# Menü: Anzeigen
function view_menu() {
  CHOICE=$(whiptail --title "📂 Anzeige-Menü" --menu "Was möchtest du anzeigen?" 15 60 5 \
  "1" "YAML anzeigen (onestack view)" \
  "2" "Parquet-Daten ansehen (onestack peek)" \
  "3" "Zurück" 3>&1 1>&2 2>&3)

  case $CHOICE in
    1) 
      FILE=$(whiptail --inputbox "Pfad zur YAML-Datei eingeben:" 10 60 3>&1 1>&2 2>&3)
      onestack view --file "$FILE" || show_error "Fehler beim Anzeigen der YAML-Datei."
      ;;
    2)
      FILE=$(whiptail --inputbox "Pfad zur Parquet-Datei eingeben:" 10 60 3>&1 1>&2 2>&3)
      onestack peek --file "$FILE" --rows 15 --meta || show_error "Fehler beim Anzeigen der Parquet-Datei."
      ;;
    3) main_menu ;;
  esac
}

# Menü: CSV laden
function load_csv() {
  FILE=$(whiptail --inputbox "Pfad zur YAML-Loader-Datei (CSV-Import):" 10 60 3>&1 1>&2 2>&3)
  if [[ ! -f "$FILE" ]]; then
    show_error "Datei nicht gefunden: $FILE"
  else
    onestack load --file "$FILE" || show_error "Ladevorgang fehlgeschlagen."
  fi
}

# Menü: Validierung
function validation_menu() {
  CHOICE=$(whiptail --title "✅ Validierungs-Menü" --menu "Was möchtest du validieren?" 15 60 5 \
  "1" "Alle YAMLs validieren (onestack test)" \
  "2" "Einzelnes Projekt validieren" \
  "3" "Zurück" 3>&1 1>&2 2>&3)

  case $CHOICE in
    1) onestack test --summary || show_error "YAML-Tests fehlgeschlagen." ;;
    2)
      PATH=$(whiptail --inputbox "Pfad zum Projektordner (z. B. projects/prj-0002):" 10 60 3>&1 1>&2 2>&3)
      onestack test --path "$PATH" --summary || show_error "Validierung fehlgeschlagen."
      ;;
    3) main_menu ;;
  esac
}

# Menü: Admin & System
function admin_menu() {
  CHOICE=$(whiptail --title "🔧 Admin-Tools" --menu "Verwaltungsoptionen" 15 60 5 \
  "1" "Git Push ausführen" \
  "2" "Session-Daten anzeigen" \
  "3" "Zurück" 3>&1 1>&2 2>&3)

  case $CHOICE in
    1)
      MESSAGE=$(whiptail --inputbox "Commit-Message für Git Push:" 10 60 "Update CLI" 3>&1 1>&2 2>&3)
      onestack push --message "$MESSAGE" || show_error "Git Push fehlgeschlagen."
      ;;
    2)
      env | grep ONESTACK_ | whiptail --title "📄 ONESTACK_SESSION Variablen" --textbox /dev/stdin 20 70
      ;;
    3) main_menu ;;
  esac
}

# Start
main_menu
