# 🧠 OneStack YSF – YAML Semantic Framework

OneStack dient als modulare, YAML-gesteuerte Datenlösung.

---

## 🔧 YSF Core Komponenten

### 🧠 OneStack YSF Modeler *(neu)*
Ziel: Modellierungs- & Semantik-Layer  
Tools: WebGUI + CLI  
Verantwortlich für:
- Dimensionen & Fakten designen
- SCD2/Surrogate Keys verwalten
- Keys & Relationships visualisieren
- Gold Layer aufbauen (dim/fact views)
- Semantic Layer für Metabase
- Measures & Aggregationen verwalten (optional)

---

### 🔄 OneStack YSF Loader *(besteht schon)*
Ziel: Operational ETL Layer  
Tools: CLI + Web + TUI  
Verantwortlich für:
- Laden, Umwandeln, Bereinigen
- Datei-Handling (in → out → history)
- View-Erzeugung
- Laden in DuckDB/PostgreSQL
- Logging, Monitoring
- Transformation über YAML

---

## ⚙️ YSF Runner (Job Execution)

---

## 🪙 Bronze → Silver → Gold Layer Konzept

| Schicht | Beschreibung |
|--------|--------------|
| Bronze | Rohdaten (CSV, Parquet) |
| Silver | Bereinigt und verbunden |
| Gold   | Auswertbare Modelle in PostgreSQL für DWH & Metabase |

---

## 🧱 Module nach Schicht

| Ebene   | Modul         | Aufgabe |
|---------|---------------|---------|
| Quelle  | YSF Loader    | Rohdaten holen, speichern |
| Bronze  | YSF Processor | Bereinigen, typisieren |
| Silver  | YSF Transformer | Joins, Businesslogik, SCD2 |
| Gold    | YSF Publisher | Export nach PostgreSQL, Views |

---

## 📄 YAML Layer: Beispiel Customer

| Schicht | Datei                     | Typ         | Beschreibung |
|---------|---------------------------|-------------|--------------|
| 1       | customer_loader.yaml      | source      | Quelle & Encoding |
| 2       | customer_bronze.yaml      | raw         | Aufnahme in Parquet (in/) |
| 3       | customers.yaml            | dimension   | SCD2, Hashes, Normalisierung |
| 4       | dim_customer.yaml         | dim_export  | Mapping nach PostgreSQL |
| 5       | customer_snapshot.yaml    | snapshot    | Historie (optional) |
| 6       | customer_metrics.yaml     | measure     | KPIs für BI (optional) |

---

## 🧠 Warum Trennung ab Loader wichtig ist:

- **Fakten** sind transaktional, oft append-only
- **Dimensionen** haben SCD2, Surrogate Keys
- Unterschiedliche Qualitätsprüfungen

---

## ✅ Kern-Typen in OneStack YSF

| Typ          | Zweck                                   | Kategorie         |
|--------------|------------------------------------------|-------------------|
| source       | CSV, API, JSON etc.                      | 🔄 Loader         |
| dimension    | Stammdaten mit SCD/SID                  | 🧱 Modell         |
| fact         | Bewegungs-/Transaktionsdaten            | 🧱 Modell         |
| measure      | KPIs, Kennzahlen                        | 📊 Reporting      |
| snapshot     | Zustand zu Zeitpunkten                  | 🕓 Historie       |
| dim_export   | Export der Dimensionen                  | 🏁 Deployment     |
| fact_export  | Export der Fakten                       | 🏁 Deployment     |

---

## 🔧 Erweiterbare Typen (optional)

- `lookup`, `bridge`, `hierarchy`, `audit`
- `cdc_stream`, `calculation`, `template`, `test`, `view`, `aggregation`, `staging`

---

## 🚚 Ladearten (`load_type` Übersicht)

| Typ        | Beschreibung                        | Besonderheit |
|------------|-------------------------------------|--------------|
| initial    | Erster kompletter Load              | löscht ggf. Ziel |
| full       | Volllast bei jedem Lauf             | teuer bei viel Daten |
| delta      | Änderungen anhand Hash/ID erkennen  | Vergleich nötig |
| incremental| Zeitbasierte Ergänzungen            | braucht Timestamp |
| cdc        | Echtzeit-Änderungen (Insert/Update/Delete) | braucht CDC-Quelle |
| append     | Nur neue Datensätze hinzufügen      | keine Prüfung |
| partial    | Teilimport (z. B. pro Monat)        | Filter nötig |
| reload     | Manuelles Neuladen                  | Recovery |
| streaming  | Kontinuierlich (z. B. Kafka)        | komplex |
| manual     | Nur manuell ausgeführt              | kein Trigger |

---

## 🧰 PostgreSQL als DWH-Ziel

- Star-Schema: `dim_customer`, `fact_sales`
- Materialisierte Views
- Indexe, Partitionierung
- Cron-Jobs / ETL via OneStack
- DB-Tests: Not Null, dbt-kompatibel

---

## 📦 Warum Parquet?

| Vorteil                  | Beschreibung |
|--------------------------|--------------|
| Spaltenbasiert           | Schnell bei SELECT |
| Komprimiert              | Wenig Speicher |
| Direkt in DuckDB nutzbar | Ohne Import |
| Tool-übergreifend        | Kompatibel mit Pandas, Spark etc. |
| Metadaten speicherbar    | UUID, Layer etc. |
| Versionierbar            | Snapshots mit Zeitstempel |
| Ideal für Data Lineage   | Klarer Datenfluss in Pfadstruktur |

---

## 🔍 Parquet im Einsatz

- `YSF Loader`: aus CSV → Parquet (`/in`)
- `YSF Processor`: Transformation → Parquet (`/out`)
- `YSF Exporter`: nach PostgreSQL schreiben
- `Snapshots`: Archivdateien

---

## 🧠 Module & Zusatzkomponenten

### 🔧 YSF Core

| Modul         | Aufgabe |
|---------------|---------|
| YSF Loader    | Quelle lesen, Parquet schreiben |
| YSF Processor | Transformieren, bereinigen |
| YSF Exporter  | Export zu PostgreSQL |
| YSF Snapshot  | Zeitpunkt sichern |
| YSF Metrics   | KPI-Berechnung |

### ⏱ Orchestrierung

| Modul              | Aufgabe |
|--------------------|---------|
| YSF Job Runner     | Führt einzelne Jobs aus |
| YSF Scheduler      | Cron/Trigger basiert |
| YSF DAG Orchestrator | Kettung von Jobs |
| YSF Parameter Store | Zentrale Konfiguration |
