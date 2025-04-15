#!/usr/bin/env python3
# ==========================================================
# 📄 Script: session_guard.py
# 🔐 Zweck : Login-Validierung, Sessions, Zugriffskontrolle
# 🔧 Version: 0.1.0
# ✏️ Status : stable
# 📅 Erstellt: 2025-04-13
# ==========================================================

import os
import uuid
import datetime

# -----------------------------------------
# 🟢 Login-Funktion (interaktiv oder via CLI)
# -----------------------------------------
def login_with_credentials(username, password):
    """
    Prüft Benutzername + Passwort und erzeugt Session.
    """
    valid_users = {
        "admin2006": "ubuntu2006",
        "dev2006": "ubuntu2006",
        "readonly2006": "ubuntu2006"
    }

    if username in valid_users and valid_users[username] == password:
        session_id = str(uuid.uuid4())

        # Setze Umgebungsvariablen
        os.environ["ONESTACK_USER"] = username
        os.environ["ONESTACK_ROLE"] = username.replace("2006", "")
        os.environ["ONESTACK_SESSION_ID"] = session_id

        # Session-Log
        with open("/tmp/onestack_session.log", "a") as log:
            log.write(f"[{datetime.datetime.now()}] LOGIN {username} | Session: {session_id}\n")

        return True
    return False

# -----------------------------------------
# 🔐 Sichere Shell prüfen
# -----------------------------------------
def is_secure_shell():
    return os.environ.get("ONESTACK_SECURE", "") == "1"

# -----------------------------------------
# 🧍 Aktueller Benutzer anzeigen
# -----------------------------------------
def whoami():
    user = os.environ.get("ONESTACK_USER", "unbekannt")
    role = os.environ.get("ONESTACK_ROLE", "unbekannt")
    session = os.environ.get("ONESTACK_SESSION_ID", "–")
    print(f"👤 Benutzer: {user}")
    print(f"🎭 Rolle   : {role}")
    print(f"🔐 Session : {session}")

# -----------------------------------------
# 🚫 Zugriff prüfen (Secure Umgebung)
# -----------------------------------------
def require_secure_shell():
    if not is_secure_shell():
        print("⛔ Zugriff nur in sicherer Umgebung erlaubt!")
        exit(1)

# -----------------------------------------
# 🔐 Direkt aus ausführbarem Shellskript nutzbar
# -----------------------------------------
if __name__ == "__main__":
    whoami()
