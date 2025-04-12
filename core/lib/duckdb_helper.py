#!/usr/bin/env python3
# ==========================================================
# 📄 Script: duckdb_helper.py
# 🧠 Zweck : Hilfsfunktionen zur Arbeit mit DuckDB
# 🔧 Version: 0.1.0
# ✏️ Status : draft
# 📅 Erstellt: 2025-04-10
# ==========================================================

import duckdb
import os
import time

def create_connection(duckdb_path=None):
    """
    Erstellt eine DuckDB-Verbindung (in-memory oder file-based).
    """
    if duckdb_path:
        os.makedirs(os.path.dirname(duckdb_path), exist_ok=True)
        print(f"🔌 Öffne DuckDB-Datei: {duckdb_path}")
        return duckdb.connect(database=duckdb_path)
    else:
        print("⚙️  Erstelle temporäre In-Memory-DuckDB")
        return duckdb.connect()

def register_parquet_view(con, parquet_file, view_name):
    """
    Registriert eine Parquet-Datei als temporäre View in DuckDB.
    """
    print(f"📄 Registriere View '{view_name}' für: {parquet_file}")
    con.execute(f"""
        CREATE OR REPLACE VIEW {view_name} AS
        SELECT * FROM read_parquet('{parquet_file}')
    """)

def run_sql(con, sql, show_result=False):
    """
    Führt SQL in DuckDB aus und misst die Laufzeit.
    """
    print(f"▶️  SQL ausführen...")
    start = time.time()
    result = con.execute(sql)
    duration = round(time.time() - start, 3)
    print(f"✅ SQL ausgeführt in {duration} Sekunden.")
    
    if show_result:
        df = result.fetch_df()
        print(df.head())

    return result

def export_to_parquet(con, sql, target_file):
    """
    Führt SQL aus und speichert Ergebnis als Parquet.
    """
    print(f"📦 Exportiere Ergebnis nach: {target_file}")
    con.execute(f"""
        COPY ({sql}) TO '{target_file}' (FORMAT PARQUET, COMPRESSION 'SNAPPY')
    """)
    print("✅ Export abgeschlossen.")
# Alias für Kompatibilität mit bestehendem Code
def duckdb_connect():
    return create_connection()
# Alias für Kompatibilität mit bestehendem Code
def duckdb_connect():
    return create_connection()
