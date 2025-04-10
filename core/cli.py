 
#!/usr/bin/env python3
"""
CLI-Einstiegspunkt für OneStack YSF

Verfügbare Kommandos:
  - run           Starte einen Node oder ein Projekt
  - validate      Validiere YAML-Konfigurationen
  - status        Zeige Projekt-/Engine-Metainfos
  - copy-template Kopiere Templates ins Projekt
"""

import argparse
import sys

def run(args):
    print(f"🚀 Running node or project: {args.target}")

def validate(args):
    print("🔍 Validating YAML files...")
    # Beispiel: iterate YAMLs and call validator here
    # from validator import validate_yaml

def show_status(args):
    print("📊 OneStack YSF Status:")
    # Hier könntest du aus engine.meta lesen oder configs anzeigen

def copy_template(args):
    print(f"📁 Copy template '{args.template}' to project '{args.project}'")
    # Hier könntest du aus /core/templates/ nach /projects/<id>/templates/ kopieren

def main():
    parser = argparse.ArgumentParser(
        description="OneStack YSF CLI – YAML Semantic Framework"
    )
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

    args = parser.parse_args()
    args.func(args)

if __name__ == "__main__":
    main()
