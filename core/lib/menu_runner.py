#!/usr/bin/env python3
# ==========================================================
# 📄 Script: menu_runner.py
# 🧠 Zweck : CLI-Menüsystem für OneStack YSF
# 🔧 Version: 0.1.0
# ✏️ Status : draft
# 📅 Erstellt: 2025-04-12
# ==========================================================

import os

def clear():
    os.system('clear' if os.name == 'posix' else 'cls')

def pause():
    input("\n⏎ Drücke Enter, um fortzufahren...")

def show_main_menu():
    clear()
    print("""🎛️  OneStack YSF – Hauptmenü
===================================
[1] Projektverwaltung
[2] YAML & Templates
[3] Exit
""")

def show_project_menu():
    clear()
    print("""📦 Projektverwaltung
-------------------------------
[1] Neues Projekt anlegen
[2] Projektstruktur anzeigen
[3] Zurück
""")

def show_yaml_menu():
    clear()
    print("""🧾 YAML & Templates
-------------------------------
[1] YAML aus CSV generieren
[2] Templates ins Projekt kopieren
[3] Zurück
""")

def handle_project_menu():
    while True:
        show_project_menu()
        choice = input("Option: ").strip()
        if choice == "1":
            os.system("bash scripts/create_project.sh")
            pause()
        elif choice == "2":
            os.system("ls -l projects/")
            pause()
        elif choice == "3":
            return

def handle_yaml_menu():
    while True:
        show_yaml_menu()
        choice = input("Option: ").strip()
        if choice == "1":
            os.system("python3 tools/generate_yaml_from_csv.py")
            pause()
        elif choice == "2":
            print("🛠 Templates kopieren folgt...")
            pause()
        elif choice == "3":
            return

def main():
    while True:
        show_main_menu()
        choice = input("Option wählen: ").strip()
        if choice == "1":
            handle_project_menu()
        elif choice == "2":
            handle_yaml_menu()
        elif choice == "3":
            print("👋 Auf Wiedersehen!")
            break
        else:
            print("❌ Ungültige Eingabe.")
            pause()

if __name__ == "__main__":
    main()
