#!/usr/bin/env python3
# ==========================================================
# 📄 Script: peek_parquet.py
# 🧠 Zweck : Zeigt Vorschau + Metadaten eines Parquet-Files
# 🔧 Version: 0.1.0
# ✏️ Status : dev
# 📅 Erstellt: 2025-04-11
# ==========================================================

import argparse
import pandas as pd
import pyarrow.parquet as pq

def peek_parquet(file_path, rows=10, show_meta=False):
    print(f"🔍 Lese Parquet-Datei: {file_path}\n")

    try:
        df = pd.read_parquet(file_path)
        print(f"📊 Vorschau ({rows} Zeilen):\n")
        print(df.head(rows))

        if show_meta:
            print("\n🔖 Metadaten:")
            table = pq.read_table(file_path)
            meta = table.schema.metadata
            if meta:
                for key, value in meta.items():
                    print(f"• {key.decode()}: {value.decode()}")
            else:
                print("⚠️ Keine Metadaten vorhanden.")
    except Exception as e:
        print(f"❌ Fehler beim Lesen: {e}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Parquet-Vorschau mit Metadaten")
    parser.add_argument("--file", required=True, help="Pfad zur Parquet-Datei")
    parser.add_argument("--rows", type=int, default=10, help="Anzahl der Zeilen (Default: 10)")
    parser.add_argument("--meta", action="store_true", help="Zeige Metadaten")

    args = parser.parse_args()
    peek_parquet(args.file, args.rows, args.meta)
