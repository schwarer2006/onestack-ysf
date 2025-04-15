#!/bin/bash
# scripts/onestack_secure_menu.sh

source /opt/onestack-ysf/core/security/session_guard.sh

# ==========================================================
# 📄 Script: onestack_secure_menu.sh
# 🧠 Zweck : Rollenabhängiges Menü in sicherer Umgebung
# 🔐 Status : stable
# 📦 Version: 0.3.0
# 📅 Erstellt: 2025-04-12
# ==========================================================

if [ "$ONESTACK_SHELL_MODE" != "secure" ]; then
  echo "⛔ Zugriff nur in sicherer Umgebung erlaubt!"
  exit 1
fi

LOCK_ICON="🔒"
USER_INFO="👤 Benutzer: $ONESTACK_USER\n🎭 Rolle: $ONESTACK_ROLE\n🔐 Session: $ONESTACK_SESSION_ID"

# Begrüßung
whiptail --title "OneStack Menü $LOCK_ICON" \
  --msgbox "$USER_INFO\n\nWillkommen in der sicheren OneStack-Umgebung." 12 60

# Rollenabhängiges Menü
case "$ONESTACK_ROLE" in

  admin)
    CHOICE=$(whiptail --title "Admin-Menü $LOCK_ICON" --menu "Aktion wählen:" 20 60 10 \
    "1" "Benutzer anzeigen" \
    "2" "Benutzer deaktivieren" \
    "3" "Systemstatus anzeigen" \
    "4" "Audit-Logs prüfen" \
    "5" "Beenden" 3>&1 1>&2 2>&3)

    case $CHOICE in
      1) onestack user list ;;
      2) read -p "Benutzername zum Deaktivieren: " U; onestack user disable --name "$U";;
      3) onestack status ;;
      4) less /opt/onestack-ysf/logs/secure_access.log ;;
      5) exit 0 ;;
    esac
    ;;

  dev)
    CHOICE=$(whiptail --title "Dev-Menü $LOCK_ICON" --menu "Aktion wählen:" 20 60 10 \
    "1" "YAML anzeigen" \
    "2" "CSV → Parquet laden" \
    "3" "Parquet anzeigen" \
    "4" "Validierung starten" \
    "5" "Beenden" 3>&1 1>&2 2>&3)

    case $CHOICE in
      1) read -p "Pfad zur YAML-Datei: " F; onestack view --file "$F";;
      2) read -p "Pfad zur Loader-YAML: " L; onestack load --file "$L";;
      3) read -p "Pfad zur Parquet-Datei: " P; onestack peek --file "$P" --rows 10 --meta;;
      4) onestack validate ;;
      5) exit 0 ;;
    esac
    ;;

  readonly)
    CHOICE=$(whiptail --title "Readonly-Menü $LOCK_ICON" --menu "Aktion wählen:" 20 60 10 \
    "1" "YAML anzeigen" \
    "2" "Parquet anzeigen" \
    "3" "Beenden" 3>&1 1>&2 2>&3)

    case $CHOICE in
      1) read -p "Pfad zur YAML-Datei: " F; onestack view --file "$F";;
      2) read -p "Pfad zur Parquet-Datei: " P; onestack peek --file "$P" --rows 10 --meta;;
      3) exit 0 ;;
    esac
    ;;

  *)
    echo "⛔ Unbekannte Rolle: $ONESTACK_ROLE"
    exit 1
    ;;
esac
