#!/usr/bin/env python3
# ==========================================================
# 📄 Script: yaml_loader.py
# 🧠 Zweck : YAML-Dateien einlesen und validieren
# 🔧 Version: 0.1.0
# ✏️ Status : stable
# 📅 Erstellt: 2025-04-10
# ==========================================================

import yaml
import os
import sys

REQUIRED_FIELDS = ["name", "type"]

def load_yaml(path):
    """
    Lädt eine YAML-Datei und gibt den Inhalt als Dictionary zurück.
    """
    if not os.path.exists(path):
        raise FileNotFoundError(f"❌ YAML-Datei nicht gefunden: {path}")

    with open(path, "r", encoding="utf-8") as f:
        try:
            data = yaml.safe_load(f)
        except yaml.YAMLError as e:
            raise Exception(f"❌ YAML-Fehler in {path}: {e}")

    # Minimal-Validierung
    for field in REQUIRED_FIELDS:
        if field not in data:
            raise ValueError(f"⚠️ Pflichtfeld '{field}' fehlt in {path}")

    return data


def load_all_yamls_from(folder, extension=".yaml"):
    """
    Lädt alle YAML-Dateien aus einem Verzeichnis (z. B. /nodes/) und gibt eine Liste zurück.
    """
    yamls = []
    if not os.path.exists(folder):
        print(f"📁 Ordner nicht gefunden: {folder}")
        return []

    for file in os.listdir(folder):
        if file.endswith(extension):
            path = os.path.join(folder, file)
            try:
                yamls.append(load_yaml(path))
            except Exception as e:
                print(f"⚠️ Fehler beim Laden von {file}: {e}")

    return yamls


def print_yaml_info(yaml_obj, show_keys=False):
    """
    Gibt eine Kurzinfo zum geladenen YAML aus.
    """
    print(f"📄 YAML: {yaml_obj.get('name')} ({yaml_obj.get('type')})")
    if show_keys:
        print(f"🔑 Felder: {list(yaml_obj.keys())}")


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("⚙️  Usage: python yaml_loader.py <pfad/zur/yaml>")
        sys.exit(1)

    path = sys.argv[1]
    y = load_yaml(path)
    print_yaml_info(y, show_keys=True)

