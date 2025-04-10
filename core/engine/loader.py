 #!/usr/bin/env python3
# ==========================================================
# 📄 Script: loader.py
# 🧠 Zweck : Lädt Daten basierend auf YAML-Konfiguration, schreibt Parquet mit Metadaten
# 🔧 Version: 0.1.0
# ✏️ Status : stable
# 📅 Erstellt: 2025-04-10
# ==========================================================
# loader.py
import os
import duckdb
import pandas as pd
import pyarrow as pa
import pyarrow.parquet as pq
from datetime import datetime
import getpass

from core.engine.utils.yaml_loader import load_yaml
from core.engine.utils.duckdb_helper import duckdb_connect


def write_parquet_with_metadata(df, output_path, metadata: dict):
    table = pa.Table.from_pandas(df)
    encoded_meta = {k: str(v).encode("utf-8") for k, v in metadata.items()}
    table = table.replace_schema_metadata(encoded_meta)
    pq.write_table(table, output_path)
    print(f"✅ Parquet geschrieben mit Metadaten: {output_path}")


def run_loader(yaml_path: str, output_dir: str = "in"):
    config = load_yaml(yaml_path)
    source = config.get("source", {})
    file_path = source.get("path")
    fmt = source.get("format", "csv")

    print(f"📥 Lade Quelle: {file_path} ({fmt.upper()})")

    # CSV oder Parquet lesen
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

    # DuckDB-Check (optional, validiert Struktur)
    con = duckdb_connect()
    con.register("df", df)
    print("🔎 Zeilenanzahl:", con.sql("SELECT COUNT(*) FROM df").fetchall()[0][0])

    # Parquet-Ziel vorbereiten
    os.makedirs(output_dir, exist_ok=True)
    base_name = os.path.basename(file_path).replace(".csv", ".parquet").replace(".json", ".parquet")
    parquet_out = os.path.join(output_dir, base_name)

    # Metadaten schreiben
    meta = {
        "type": config.get("type", "source"),
        "name": config.get("name", "unknown"),
        "source_file": file_path,
        "load_type": config.get("load_type", "unknown"),
        "created_by": getpass.getuser(),
        "created_at": datetime.now().isoformat(),
        "project": config.get("project", "default"),
    }

    write_parquet_with_metadata(df, parquet_out, meta)



