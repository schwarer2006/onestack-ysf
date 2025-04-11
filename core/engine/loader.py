#!/usr/bin/env python3
# ==========================================================
# 📄 Script: loader.py
# 🧠 Zweck : Lädt Daten basierend auf YAML-Konfiguration, schreibt Parquet mit Metadaten
# 🔧 Version: 0.2.0
# ✏️ Status : stable
# 📅 Erstellt: 2025-04-10
# ==========================================================

import os
import pandas as pd
import getpass
from datetime import datetime

from core.lib.yaml_loader import load_yaml
from core.lib.duckdb_helper import duckdb_connect
from core.lib.meta_writer import write_parquet_with_metadata


def run_loader(yaml_path: str, output_dir: str = "in"):
    config = load_yaml(yaml_path)
    source = config.get("source", {})
    file_path = source.get("path")
    fmt = source.get("format", "csv").lower()

    print(f"📥 Lade Quelle: {file_path} ({fmt.upper()})")

    # Datei einlesen
    if fmt == "csv":
        df = pd.read_csv(
            file_path,
            delimiter=source.get("delimiter", ","),
            encoding=source.get("encoding", "utf-8"),
            header=0 if source.get("header", True) else None,
        )
    elif fmt == "parquet":
        df = pd.read_parquet(file_path)
    else:
        raise ValueError(f"❌ Format {fmt} wird nicht unterstützt.")

    # DuckDB-Check (optional)
    con = duckdb_connect()
    con.register("df", df)
    row_count = con.sql("SELECT COUNT(*) FROM df").fetchall()[0][0]
    print(f"🔎 Zeilenanzahl: {row_count}")

    # Zielpfad erzeugen
    os.makedirs(output_dir, exist_ok=True)
    base_name = os.path.basename(file_path).replace(".csv", ".parquet").replace(".json", ".parquet")
    parquet_out = os.path.join(output_dir, base_name)

    # Metadaten erstellen
    meta = {
        "type": config.get("type", "source"),
        "name": config.get("name", "unknown"),
        "source_file": file_path,
        "load_type": config.get("load_type", "unknown"),
        "created_by": getpass.getuser(),
        "created_at": datetime.now().isoformat(),
        "project": config.get("project", "default"),
    }

    # Schreiben
    write_parquet_with_metadata(df, parquet_out, meta)


if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser(description="OneStack YSF Loader")
    parser.add_argument("--yaml", required=True, help="Pfad zur YAML-Konfiguration")
    parser.add_argument("--output", default="in", help="Zielordner für Parquet-Dateien")
    args = parser.parse_args()

    run_loader(args.yaml, output_dir=args.output)
