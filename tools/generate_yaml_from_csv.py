#!/usr/bin/env python3
# ==========================================================
# 📄 Script: generate_yaml_from_csv.py
# 🧠 Zweck : Erstellt eine YAML-Loader-Datei aus CSV-Metadaten
# 🔧 Version: 0.2.0
# ✏️ Status : stable
# 📅 Erstellt: 2025-04-12
# ==========================================================

import os
import argparse
import pandas as pd
import yaml
from datetime import datetime
import getpass

def infer_dtype(dtype):
    if pd.api.types.is_integer_dtype(dtype):
        return "int"
    elif pd.api.types.is_float_dtype(dtype):
        return "float"
    elif pd.api.types.is_bool_dtype(dtype):
        return "bool"
    elif pd.api.types.is_datetime64_any_dtype(dtype):
        return "datetime"
    else:
        return "string"

def generate_yaml(csv_path, output_dir, name, project, node=None, delimiter=",", encoding="utf-8"):
    df = pd.read_csv(csv_path, nrows=1000, delimiter=delimiter, encoding=encoding)

    columns = []
    for col in df.columns:
        dtype = infer_dtype(df[col].dtype)
        columns.append({
            "name": col,
            "type": dtype,
            "nullable": True
        })

    yaml_dict = {
        "type": "source",
        "name": name,
        "project": project,
        "source": {
            "format": "csv",
            "path": csv_path,
            "delimiter": delimiter,
            "encoding": encoding,
            "header": True
        },
        "columns": columns,
        "created_by": getpass.getuser(),
        "created_at": datetime.now().isoformat()
    }

    # Pfad aufbauen
    if node:
        full_path = os.path.join(output_dir, "nodes", node, "config")
    else:
        full_path = os.path.join(output_dir, "config")

    os.makedirs(full_path, exist_ok=True)
    yaml_path = os.path.join(full_path, f"{name}.yaml")

    with open(yaml_path, "w") as f:
        yaml.dump(yaml_dict, f, sort_keys=False)

    print(f"✅ YAML geschrieben: {yaml_path}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Erzeuge YAML-Loader aus CSV-Metadaten")
    parser.add_argument("--csv", required=True, help="Pfad zur CSV-Datei")
    parser.add_argument("--output", required=True, help="Basisverzeichnis des Projekts (z. B. projects/prj-0002)")
    parser.add_argument("--name", required=True, help="Name des YAML-Files (z. B. customer_loader)")
    parser.add_argument("--project", required=True, help="Projekt-ID (z. B. prj-0002)")
    parser.add_argument("--node", required=False, help="Node-ID (z. B. node-0001)")
    parser.add_argument("--delimiter", default=",", help="CSV-Trennzeichen")
    parser.add_argument("--encoding", default="utf-8", help="Encoding der CSV-Datei")

    args = parser.parse_args()

    generate_yaml(
        csv_path=args.csv,
        output_dir=args.output,
        name=args.name,
        project=args.project,
        node=args.node,
        delimiter=args.delimiter,
        encoding=args.encoding
    )
