
# 📁 OneStack YSF – Verzeichnisstruktur (Stand: 2025-04-10)

Dies ist die vollständige Referenzstruktur für ein OneStack YSF-System.

## 🌳 Hauptstruktur

```
/opt/onestack-ysf/
├── core/                          # 🧠 Core Engine & CLI
│   ├── cli.py
│   ├── validator.py
│   ├── engine/
│   │   ├── loader.py
│   │   ├── processor.py
│   │   ├── transformer.py
│   │   ├── publisher.py
│   │   ├── engine.meta
│   │   └── README.md
│
├── scripts/                       # 🛠 Hilfsskripte
│   ├── bootstrap.sh
│   ├── install.sh
│   ├── preflight_check.sh
│   ├── setup.sh
│   ├── update_engine_meta.py
│   ├── import_testlog.py
│   └── script_meta.py
│
├── shared/                        # 📦 Statische Stammdaten (z. B. Dimensionen)
│   ├── dim_date.parquet
│
├── storage/                       # 💾 Datenhaltung (DuckDB, Parquet)
│   └── duckdb/
│       ├── dev/
│       ├── qa/
│       ├── prod/
│       └── system/
│           └── onestack_meta.duckdb  # 🧠 Optionale Konfigurationsdatenbank
│
├── logs/                          # 🧾 System- und Testlogs
│   ├── core/
│   ├── cli.log
│   └── test_results.log
│
├── projects/                      # 📁 Projektverzeichnis (mandantenfähig)
│   └── prj-0001/
│       ├── config/
│       ├── nodes/
│       │   └── node-0001/
│       ├── orchestration/
│       ├── templates/             # Team- oder projektspezifische Vorlagen
│       ├── tests/
│       ├── logs/
│       └── README.md
│
├── .gitignore                     # Git-Konfiguration
├── README.md                      # Projektübersicht
├── CHANGELOG.md                   # Changelog aller Versionen
└── config.yaml                    # 🌍 Zentrale Systemkonfiguration
```

## 🧠 Hinweise

- `config.yaml`: Steuerung von Umgebung, Logging, Datenpfad, DuckDB-Nutzung
- `onestack_meta.duckdb`: enthält Tabellen `projects`, `nodes`, `engine_modules`
- `bootstrap.sh`: legt Projekte an und schreibt parallel YAML + DuckDB
- `setup.sh`: verkettet Preflight → Install → Bootstrap (automatisch)
- `.gitignore`: schützt Logs, Caches, temporäre Dateien und DuckDB-Dateien

## 🔧 Optional
- WebGUI-Anbindung
- Versionsverwaltung in `engine.meta`
- Metabase-Dashboard via Logs oder DuckDB

