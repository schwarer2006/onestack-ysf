# 🐍 Python Packages für OneStack YSF

Diese Übersicht listet alle relevanten Python-Pakete, die für die Funktionalität und Erweiterbarkeit von OneStack YSF empfohlen werden.

| Kategorie         | Package                | Zweck / Beschreibung                                           |
|------------------|------------------------|----------------------------------------------------------------|
| **YAML + Config**| `pyyaml`               | Einlesen und Parsen von `.yaml` Dateien                        |
|                  | `python-dotenv`        | Einlesen von `.env`-Dateien für Umgebungsvariablen            |
| **CLI / Tools**  | `argparse`             | Standardmodul für Kommandozeilen (wird mit Python geliefert)  |
|                  | `rich`                 | Optional für bunte CLI-Ausgaben, Tabellen, Logs               |
| **Data Engine**  | `duckdb`               | Kern-Datenbank für Verarbeitung & SQL-Queries                  |
|                  | `pandas`               | Datenmanipulation (Parquet, CSV, DataFrames)                  |
|                  | `pyarrow`              | Parquet-Unterstützung für `pandas` und DuckDB                 |
| **Filesystem**   | `fsspec`               | Zugriff auf lokale + entfernte Dateisysteme                   |
|                  | `pathlib`              | Standardmodul für Pfad-Handling (Python 3.5+)                  |
| **Validierung**  | `cerberus` / `voluptuous` | Schema-basierte YAML-Prüfung (optional)                    |
| **Testing**      | `pytest`               | Unit-Tests für Module und Pipelines                           |
|                  | `coverage`             | Testabdeckung messen                                           |
| **Logging**      | `loguru` *(optional)*  | Modernes Logging mit Rotation und Kontext                     |
|                  | `logging`              | Standard-Logging (Python built-in)                            |
 
