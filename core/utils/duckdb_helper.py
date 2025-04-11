# duckdb_helper.py
import duckdb

def duckdb_connect(memory: bool = True, db_path: str = "temp.duckdb"):
    if memory:
        return duckdb.connect(database=':memory:')
    return duckdb.connect(database=db_path)
