#!/usr/bin/env python3
# ==========================================================
# 📄 Script: meta_writer.py
# 🧠 Zweck : Schreibt Metadaten in Parquet-Dateien
# 🔧 Version: 0.1.0
# ✏️ Status : stable
# 📅 Erstellt: 2025-04-10
# ==========================================================

import pyarrow as pa
import pyarrow.parquet as pq

def write_parquet_with_metadata(df, output_path, metadata: dict):
    """
    Schreibt ein DataFrame als Parquet mit Key/Value-Metadaten in den Footer.
    """
    table = pa.Table.from_pandas(df)
    encoded_meta = {k: str(v).encode("utf-8") for k, v in metadata.items()}
    table = table.replace_schema_metadata(encoded_meta)
    pq.write_table(table, output_path)
    print(f"✅ Parquet geschrieben mit Metadaten: {output_path}")

