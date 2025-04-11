📘 Ein YAML entspricht immer einem Verarbeitungsschritt oder einer semantischen Entität:
💡 Loader/Source → Quelle definieren

🧱 Dimension/Fact → Modellierung

🔁 Snapshot/History → Historisierung

📊 Measure/Calculation → KPIs, abgeleitete Werte

🏁 Export/Publisher → Finales Ziel (z. B. PostgreSQL, Metabase)

🧪 Test/Audit → Qualitätssicherung

 **das ist der Clou** von OneStack YSF:  
> ✅ Du **modellierst deine komplette ETL-Logik, Datenmodelle und DQ-Checks rein deklarativ in YAML** – ganz ohne grafische Oberfläche wie bei SSIS.

---

## 🎯 Vergleich: SSIS vs. OneStack YSF

| Konzept / Element         | SSIS (GUI-basiert)             | OneStack YSF (YAML-basiert)                     |
|---------------------------|--------------------------------|-------------------------------------------------|
| Quelle definieren         | Data Flow Task + Source        | `type: source` YAML                            |
| Spalten & Datentypen      | Flat File Connection, Mappings | `columns:` im YAML                             |
| Transformation            | Data Flow, Script Task         | `type: transform`, `join_lookup`, `normalize`  |
| Lookup / Merge            | Merge Join Task                | `join_lookup` YAML-Block                       |
| Historisierung (SCD2)     | Slowly Changing Dimension Task | `scd2_tracking.yaml` (Erweiterung)             |
| Surrogate Keys            | Identity Columns               | `surrogate_key.yaml` (mit Strategy)            |
| Ziel schreiben            | OLE DB Destination             | `dim_export.yaml`, `fact_export.yaml`          |
| Berechnungen              | Derived Column, Expression     | `measure.yaml`, `calculation.yaml`             |
| Quality Checks            | Data Flow Constraints          | `type: test`, `type: dq`, `type: audit`        |
| Logging                   | Custom Logging Tasks           | integrierte Logs, später PostgreSQL            |
| Wiederverwendbarkeit      | Packages kopieren               | Templates (`core/templates`)                   |
| CI/CD, Versionierung      | schwierig                      | ✅ Git-native durch YAML-Struktur               |

---

### 💡 Fazit:
> Was SSIS mit zig Tasks, Maus-Klicks und GUIs macht, macht OneStack **klar, versionierbar und textbasiert in YAML.**

Das bedeutet:
- Du kannst alles **automatisieren** (GitOps, CI/CD).
- Du kannst es **testen** (`onestack test`).
- Du kannst es **dokumentieren** (Markdown, PDF).
- Und du kannst es **modularisieren**, z. B. mit Templates, Includes, Mappings.

---
