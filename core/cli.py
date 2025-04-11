#!/usr/bin/env python3
# ==========================================================
# 📄 Script: cli.py
# 🧠 Zweck : OneStack CLI – Startpunkt für Kommandos
# 🔧 Version: 0.2.0
# ✏️ Status : stable
# 📅 Erstellt: 2025-04-11
# ==========================================================

"""
CLI-Einstiegspunkt für OneStack YSF

Verfügbare Kommandos:
  - run           Starte einen Node oder ein Projekt
  - validate      Validiere YAML-Konfigurationen
  - status        Zeige Projekt-/Engine-Metainfos
  - copy-template Kopiere Templates ins Projekt
  - test          YAML-Test aller Nodes (Basisvalidierung)
  - view          Zeige Datei-Inhalt im Terminal (yaml/log/py etc.)
  - push          Git Push mit optionaler Commit-Message
"""

import os
import sys
import argparse
import yaml
from datetime import datetime

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))
from core.lib.role_checker import is_allowed, get_role
from core.lib.test_runner import test_all_yaml

LOG_FILE = "logs/test_results.log"

# ----------------------------------------------------------
# Hauptfunktionen
# ----------------------------------------------------------

def run(args):
    print(f"🚀 Running node or project: {args.target}")
    # TODO: Node-Runner starten

def validate(args):
    print("🔍 Validating YAML files...")
    # TODO: Erweiterbar mit cerberus/voluptuous

def show_status(args):
    print("📊 OneStack YSF Status:")
    # TODO: Version aus engine.meta lesen und anzeigen

def copy_template(args):
    print(f"📁 Kopiere Template '{args.template}' nach Projekt '{args.project}'...")
    # TODO: Template-Datei von core/templates/ in projects/<id>/templates/ kopieren

def validate_yaml_file(filepath):
    required_keys = ["type", "name"]
    try:
        with open(filepath, 'r') as f:
            data = yaml.safe_load(f)
        for key in required_keys:
            if key not in data:
                return False, f"❌ {filepath}: Schlüssel '{key}' fehlt"
        return True, f"✅ OK: {filepath}"
    except Exception as e:
        return False, f"❌ Fehler beim Parsen {filepath}: {e}"

def view_file(args):
    filepath = args.file
    head = args.head
    plain = args.plain
    ftype = args.type

    if not os.path.exists(filepath):
        print(f"❌ Datei nicht gefunden: {filepath}")
        return

    if not ftype:
        ext = filepath.split(".")[-1]
        ftype = ext.lower()

    with open(filepath, "r") as f:
        lines = f.readlines()

    if head:
        lines = lines[:head]

    if plain or ftype in ["log", "txt"]:
        for line in lines:
            print(line.strip())
    elif ftype == "yaml":
        try:
            data = yaml.safe_load("".join(lines))
            print(yaml.dump(data, sort_keys=False, allow_unicode=True))
        except Exception as e:
            print(f"❌ YAML-Parsing fehlgeschlagen: {e}")
    elif ftype == "py":
        for line in lines:
            print(line.rstrip())
    else:
        print("⚠️ Unbekannter Typ, Ausgabe als Plaintext:")
        for line in lines:
            print(line.strip())

def git_push(args):
    import subprocess
    message = args.message if args.message else f"🔄 Auto-Commit: {datetime.now().isoformat()}"

    try:
        print("🌀 Git: Add changes...")
        subprocess.run(["git", "add", "."], check=True)

        print(f"📝 Commit mit Message: {message}")
        subprocess.run(["git", "commit", "-m", message], check=True)

        print("📤 Push nach GitHub...")
        subprocess.run(["git", "push"], check=True)

        print("✅ Git Push erfolgreich abgeschlossen.")
    except subprocess.CalledProcessError:
        print("❌ Fehler beim Git Push – prüfe deinen Commit oder Netzwerk.")

# ----------------------------------------------------------
# CLI Setup
# ----------------------------------------------------------

def main():
    parser = argparse.ArgumentParser(description="OneStack YSF CLI – YAML Semantic Framework")
    subparsers = parser.add_subparsers(dest="command", required=True)

    # run
    run_parser = subparsers.add_parser("run", help="Starte Node oder Projekt")
    run_parser.add_argument("target", help="Projekt- oder Node-ID (z. B. prj-0001 oder node-0001)")
    run_parser.set_defaults(func=run)

    # validate
    validate_parser = subparsers.add_parser("validate", help="Validiere YAML-Dateien")
    validate_parser.set_defaults(func=validate)

    # status
    status_parser = subparsers.add_parser("status", help="Zeige Status & Versionen")
    status_parser.set_defaults(func=show_status)

    # copy-template
    template_parser = subparsers.add_parser("copy-template", help="Kopiere Template ins Projekt")
    template_parser.add_argument("--template", required=True, help="Name des Templates (z. B. basic_dimension)")
    template_parser.add_argument("--project", required=True, help="Projekt-ID (z. B. prj-0001)")
    template_parser.set_defaults(func=copy_template)

    # test
    test_parser = subparsers.add_parser("test", help="Testet YAMLs aller Projekte (Basis-Checks)")
    test_parser.add_argument("--path", help="Projektpfad, z. B. projects/prj-0001", default="projects")
    test_parser.add_argument("--logfile", help="Pfad zur Log-Datei", default="logs/test_results.log")
    test_parser.add_argument("--markdown-report", action="store_true", help="Erzeuge Markdown-Testreport")
    test_parser.add_argument("--summary", action="store_true", help="Zeigt eine kompakte Zusammenfassung am Ende")
    test_parser.set_defaults(func=test_all_yaml)

    # view
    view_parser = subparsers.add_parser("view", help="Zeige Datei-Inhalt im Terminal")
    view_parser.add_argument("--file", required=True, help="Pfad zur Datei (z. B. *.yaml, *.log)")
    view_parser.add_argument("--type", help="Dateityp (yaml, py, log...)")
    view_parser.add_argument("--plain", action="store_true", help="Plaintext-Ausgabe")
    view_parser.add_argument("--head", type=int, help="Nur die ersten N Zeilen anzeigen")
    view_parser.set_defaults(func=view_file)

    # push
    push_parser = subparsers.add_parser("push", help="Führt Git Add/Commit/Push aus")
    push_parser.add_argument("--message", help="Commit-Message")
    push_parser.set_defaults(func=git_push)

    # --- Parse + Rollenprüfung ---
    args = parser.parse_args()
    if not is_allowed(args.command):
        print(f"⛔ Zugriff verweigert: Deine Rolle ({get_role()}) darf '{args.command}' nicht ausführen.")
        return

    args.func(args)

if __name__ == "__main__":
    main()
