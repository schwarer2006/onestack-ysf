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
 
Sehr gern, Erik! Hier ist dein **CLI Command Sheet für OneStack YSF** – im **Markdown-Format** (du kannst es direkt in GitHub, VS Code oder MkDocs einbinden) und auf Wunsch exportiere ich es dir auch als **PDF**.

---

# 📘 OneStack YSF – CLI Command Sheet

> **Version:** v1.0  
> **Stand:** April 2025  
> **Autor:** Erik & ChatGPT

---

## 🧭 Übersicht – OneStack CLI-Befehle

| Befehl                        | Beschreibung                                                                 |
|-------------------------------|------------------------------------------------------------------------------|
| `onestack init`              | Erstellt ein neues Projekt mit YAML-Struktur                                 |
| `onestack run`               | Führt DAGs und Transformationen lt. `onestack.yaml` aus                      |
| `onestack dq`                | Führt Datenqualitätschecks lt. `dq.yaml` durch                               |
| `onestack build`             | Kombiniert `run`, `dq` und `docs` zu einem vollständigen Durchlauf          |
| `onestack validate`          | Prüft Syntax, Struktur und Referenzen der YAML-Dateien                       |
| `onestack docs`              | Generiert automatische Doku aus YAML + SQL als Markdown / JSON              |
| `onestack plugin list`       | Zeigt alle installierten Plugins und Erweiterungen                          |

---

## 🛠️ Erweiterte Befehle (vorgeschlagen / in Entwicklung)

| Befehl                        | Beschreibung                                                                 |
|-------------------------------|------------------------------------------------------------------------------|
| `onestack load`              | Lädt CSV, JSON oder Parquet-Dateien über YAML-Konfiguration                  |
| `onestack export`            | Exportiert Ergebnisse nach PostgreSQL, S3, REST-API etc.                     |
| `onestack graph`             | Zeigt DAG-Visualisierung als Mermaid, ASCII oder Bild                        |
| `onestack config show`       | Zeigt eingelesene YAML-Konfiguration im Projekt                              |
| `onestack status`            | Zeigt aktuellen Zustand / Ergebnis letzter Runs                              |
| `onestack reset`             | Entfernt temporäre Laufdaten, Logs oder Checkpoints                         |
| `onestack plugin install`    | Installiert ein Plugin über PyPI oder lokalen Pfad                           |
| `onestack shell`             | Öffnet interaktive Python Shell mit Projektkontext                           |
| `onestack rerun`             | Wiederholt den letzten Run oder nur fehlgeschlagene Pipelines                |
| `onestack audit`             | Zeigt Audit Trail & History über Runs, DQ und Änderungen                     |
| `onestack report`            | Erstellt Markdown-/PDF-Report mit DQ-Ergebnissen, Statistiken und Logs       |
| `onestack serve`             | Startet lokale API / Web GUI zur Projektsteuerung                            |

---

## 🧪 Beispiele

```bash
# Neues Projekt initialisieren
onestack init -n sales_demo

# DAG ausführen
onestack run -p projects/sales_demo/onestack.yaml

# Datenqualität prüfen
onestack dq -p projects/sales_demo/dq.yaml

# Alles auf einmal
onestack build -p projects/sales_demo/

# Visualisiere DAG als Mermaid-Datei
onestack graph -p projects/sales_demo/ -o dag.mmd
```

---

## 📦 Optional: Plugins

Wenn Plugins wie z. B. `onestack-pandra`, `onestack-s3`, `onestack-metabase` installiert sind, erweitern sich die CLI-Kommandos automatisch:

```bash
onestack pandra validate
onestack s3 upload
onestack metabase sync
```

---

## 📄 Lizenz & Kontakt

OneStack YSF ist ein Open DataOps Framework.  
Entwickelt von Erik, gepflegt im Projekt **onestack-ysf**.  
Fragen? → info@deinprojekt.ch

---

## 📥 PDF-Version gefällig?

👉 Sag einfach *„Exportiere als PDF“* – ich mache dir sofort eine schön formatierte, druckfähige Version (inkl. Logo, Farben, Fußzeile etc.)

Willst du das jetzt als PDF oder gleich auch ins GitHub-Wiki oder in deine Readme integrieren?
