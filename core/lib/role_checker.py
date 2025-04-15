# ==========================================================
# 📄 Script: role_checker.py
# 🧠 Zweck : Rollenprüfung für OneStack CLI-Kommandos
# 🔧 Version: 0.2.0
# ✏️ Status : stable
# 📅 Erstellt: 2025-04-11
# ==========================================================

import os
import yaml
from pathlib import Path

ROLES_FILE = Path(__file__).resolve().parent.parent / "config" / "roles.yaml"

def get_role():
    """
    Liest die aktuelle Rolle aus der Umgebungsvariable ONESTACK_ROLE.
    """
    return os.environ.get("ONESTACK_ROLE", "readonly")

def is_allowed(command):
    """
    Prüft, ob der gegebene Befehl für die aktuelle Rolle erlaubt ist.
    """
    role = get_role()
    if not os.path.exists(ROLES_FILE):
        return True  # Keine Einschränkung bei fehlender Datei
    with open(ROLES_FILE, "r") as f:
        data = yaml.safe_load(f)
    role_data = data.get("roles", {}).get(role, {})
    allowed = role_data.get("allowed_commands", [])
    return command in allowed

if __name__ == "__main__":
    print(f"👤 Rolle erkannt: {get_role()}")
