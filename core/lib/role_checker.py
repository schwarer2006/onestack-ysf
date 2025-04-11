#!/usr/bin/env python3
# ==========================================================
# 📄 Script: role_checker.py
# 🛡️ Zweck : Ermittelt Nutzerrolle & prüft CLI-Berechtigungen
# 🔧 Version: 0.1.0
# ✏️ Status : draft
# 📅 Erstellt: 2025-04-11
# ==========================================================

import os
import pwd
import grp
import yaml

ROLES_FILE = "core/config/roles.yaml"
DEFAULT_ROLE = "readonly"

def get_user_groups():
    user = pwd.getpwuid(os.getuid()).pw_name
    return [grp.getgrgid(gid).gr_name for gid in os.getgroups()]

def get_role():
    groups = get_user_groups()
    if "onestackadmin" in groups:
        return "admin"
    elif "onestackdev" in groups:
        return "dev"
    elif "onestackro" in groups:
        return "readonly"
    return DEFAULT_ROLE

def is_allowed(command):
    role = get_role()
    if not os.path.exists(ROLES_FILE):
        return True  # Wenn Datei fehlt, keine Einschränkung
    with open(ROLES_FILE, "r") as f:
        data = yaml.safe_load(f)
    allowed = data.get("roles", {}).get(role, [])
    return command in allowed

if __name__ == "__main__":
    print(f"👤 Rolle erkannt: {get_role()}")
