#!/usr/bin/env python3
# ==========================================================
# 📄 Script    : core/tools/scaffold_script.py
# 🧠 Zweck     : Erstellt Bash-Skripte mit Standard-Header
# 🔧 Version   : 0.1.0
# ✏️ Status    : stable
# 📅 Erstellt  : 2025-04-13
# ==========================================================

import argparse
from datetime import datetime
import os

def create_script(script_name, version="0.1.0", status="draft", author="Erik / OneStack Dev"):
    now = datetime.now().strftime("%Y-%m-%d")
    header = f"""#!/bin/bash
# ==========================================================
# 📄 Script    : {script_name}
# 🧠 Zweck     : [TODO: Beschreibung einfügen]
# 🔧 Version   : {version}
# ✏️ Status    : {status}
# 👤 Autor     : {author}
# 📅 Erstellt  : {now}
# 🛠 Zuletzt   : {now}
# ==========================================================

# Dein Code beginnt hier
"""

    if not script_name.endswith(".sh"):
        script_name += ".sh"

    if os.path.exists(script_name):
        print(f"❌ Datei existiert bereits: {script_name}")
        return

    with open(script_name, "w") as f:
        f.write(header)

    os.chmod(script_name, 0o755)
    print(f"✅ Skript erstellt: {script_name}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Erzeuge ein Bash-Skript mit OneStack-Header")
    parser.add_argument("--name", required=True, help="Name des Skripts (z. B. init_project_env.sh)")
    parser.add_argument("--version", default="0.1.0", help="Versionsnummer")
    parser.add_argument("--status", default="draft", choices=["draft", "stable", "experimental", "deprecated"])
    parser.add_argument("--author", default="Erik / OneStack Dev", help="Autor des Skripts")

    args = parser.parse_args()
    create_script(args.name, args.version, args.status, args.author)
