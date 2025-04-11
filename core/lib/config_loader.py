#!/usr/bin/env python3
# ==========================================================
# 📄 Script: config_loader.py
# 🧠 Zweck : Lädt globale + projektbezogene Konfigurationen
# 🔧 Version: 0.1.0
# ✏️ Status : stable
# 📅 Erstellt: 2025-04-10
# ==========================================================

import os
import yaml
from dotenv import load_dotenv

def load_yaml(path):
    """
    Lädt eine YAML-Datei und gibt sie als dict zurück.
    """
    if not os.path.exists(path):
        return {}
    with open(path, "r", encoding="utf-8") as f:
        return yaml.safe_load(f) or {}

def merge_dicts(base, override):
    """
    Rekursive Merge-Logik: override überschreibt base.
    """
    for key, value in override.items():
        if isinstance(value, dict) and key in base:
            merge_dicts(base[key], value)
        else:
            base[key] = value
    return base

class Config:
    def __init__(self, project_path=None):
        self.global_config = load_yaml("/opt/onestack-ysf/config.yaml")
        self.project_config = {}

        if project_path:
            path = os.path.join(project_path, "config", "config.yaml")
            self.project_config = load_yaml(path)

        # Optional .env laden
        dotenv_path = os.path.join(project_path or ".", ".env")
        if os.path.exists(dotenv_path):
            load_dotenv(dotenv_path)

        # Konfiguration mergen
        self.config = merge_dicts(self.global_config.copy(), self.project_config)

    def get(self, key, default=None):
        return self.config.get(key, default)

    def get_nested(self, *keys, default=None):
        cfg = self.config
        for k in keys:
            cfg = cfg.get(k)
            if cfg is None:
                return default
        return cfg

    def dump(self):
        import pprint
        pprint.pprint(self.config)


