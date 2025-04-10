# 🚀 type_publish – Templates für Daten-Exports

Diese Templates definieren generische Ausgabeziele für OneStack YSF Pipelines.

## Enthaltene Vorlagen

| Datei                    | Zielsystem        | Beschreibung                       |
|--------------------------|-------------------|------------------------------------|
| to_parquet_template.yaml | Parquet-File      | Lokale Datei im Parquet-Format     |
| to_duckdb_template.yaml  | DuckDB-Datenbank  | Tabelle in lokaler DuckDB speichern|
| to_postgres_template.yaml| PostgreSQL        | Per SQL direkt in Postgres schreiben|
