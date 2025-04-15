#!/usr/bin/env python3
# ==========================================================
# 📄 Script: refactor_paths.py
# 🧠 Zweck : Alte Projekt-/Workspace-Pfade erkennen & ersetzen
# 🔧 Version: 0.1.0
# ✏️ Status : preview
# 📅 Erstellt: 2025-04-12
# ==========================================================

import os
import argparse

OLD_PATTERNS = {
    "projects/": "os.getenv('WORKSPACE_ROOT', '/opt/workspace') + '/projects/'",
    "/data/workspace": "os.getenv('DATAPOOL_ROOT', '/opt/datapool')",
    "/opt/onestack-ysf/projects": "os.getenv('WORKSPACE_ROOT', '/opt/workspace') + '/projects'"
}

def scan_and_replace(directory, dry_run=True):
    for root, _, files in os.walk(directory):
        for file in files:
            if file.endswith((".py", ".sh", ".yaml")):
                filepath = os.path.join(root, file)
                with open(filepath, "r", encoding="utf-8") as f:
                    content = f.read()

                modified = False
                new_content = content
                for old, new in OLD_PATTERNS.items():
                    if old in new_content:
                        print(f"🔎 {filepath} enthält: {old}")
                        modified = True
                        new_content = new_content.replace(old, new)

                if modified and not dry_run:
                    with open(filepath, "w", encoding="utf-8") as f:
                        f.write(new_content)
                    print(f"✅ Ersetzt in: {filepath}")

def main():
    parser = argparse.ArgumentParser(description="Refactore alte Projektpfade in Code & YAML")
    parser.add_argument("--path", default=".", help="Pfad zum Startverzeichnis (Standard: .)")
    parser.add_argument("--apply", action="store_true", help="Änderungen direkt anwenden")
    args = parser.parse_args()

    scan_and_replace(args.path, dry_run=not args.apply)

if __name__ == "__main__":
    main()
