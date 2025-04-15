#!/usr/bin/env python3
# ==========================================================
# 📄 Script: loader.py
# 🧠 Zweck : Lädt Daten basierend auf YAML-Konfiguration, schreibt Parquet mit Metadaten
# 🔧 Version: 0.2.0
# ✏️ Status : stable
# 📅 Erstellt: 2025-04-11
# ==========================================================

import os
import getpass
import pandas as pd
import duckdb
from datetime import datetime
import pyarrow as pa
import pyarrow.parquet as pq
from core.lib.duckdb_helper import duckdb_connect
from core.lib.yaml_loader import load_yaml

def write_parquet_with_metadata(df, output_path, metadata: dict):
    table = pa.Table.from_pandas(df)
    encoded_meta = {k: str(v).encode("utf-8") for k, v in metadata.items()}
    table = table.replace_schema_metadata(encoded_meta)
    pq.write_table(table, output_path)
    print(f"✅ Parquet geschrieben: {output_path}")


def run_loader(yaml_path: str, output_dir: str = "auto"):
    config = load_yaml(yaml_path)
    source = config.get("source", {})
    file_path = source.get("path")
    fmt = source.get("format", "csv")

    # 🔁 Automatischer Zielpfad setzen, wenn "auto"
    if output_dir == "auto":
        project = config.get("project", "unknown_project")
        node = config.get("node", "unknown_node")
        output_dir = f"/data/workspace/{project}/{node}/in"
        os.makedirs(output_dir, exist_ok=True)
        print(f"📁 Zielverzeichnis automatisch gesetzt auf: {output_dir}")

    if not os.path.exists(file_path):
        raise FileNotFoundError(f"❌ Datei nicht gefunden: {file_path}")

    print(f"📥 Lade Datei: {file_path} ({fmt.upper()})")

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
        raise ValueError(f"❌ Format {fmt} nicht unterstützt.")

    # Optional: DuckDB Preview
    con = duckdb_connect()
    con.register("df", df)
    print("🔎 Vorschau: ", con.sql("SELECT COUNT(*) FROM df").fetchone()[0], "Zeilen")

    # Ausgabe vorbereiten
    os.makedirs(output_dir, exist_ok=True)
    base_name = os.path.basename(file_path).replace(".csv", ".parquet").replace(".json", ".parquet")
    parquet_path = os.path.join(output_dir, base_name)

    # Metadaten
    meta = {
        "type": config.get("type", "source"),
        "name": config.get("name", "unknown"),
        "source_file": file_path,
        "project": config.get("project", "default"),
        "load_type": config.get("load_type", "unknown"),
        "created_by": getpass.getuser(),
        "created_at": datetime.now().isoformat(),
        "row_count": len(df),
    }

    write_parquet_with_metadata(df, parquet_path, meta)


if __name__ == "__main__":
    import sys
    if len(sys.argv) < 2:
        print("⚠️  Usage: loader.py <yaml_path>")
        sys.exit(1)

    run_loader(sys.argv[1])
