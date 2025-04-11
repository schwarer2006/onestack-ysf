cli.py
Bietet onestack run, onestack status, onestack validate, ...

Nutzt argparse / click zur Steuerung

validator.py
Liest YAMLs ein

Prüft auf Struktur, Schlüssel, erforderliche Felder

Gibt Fehler, Warnungen oder Linter-Hinweise

config_loader.py
Lädt config.yaml

Kombiniert ggf. mit .env Variablen

Liefert Config als Dict oder Namespace

meta_manager.py
Liest & schreibt engine.meta

Versionskontrolle & Modul-Infos

Exportierbar für status oder Metabase

engine/*.py
Sind die Funktionskerne: Load → Process → Transform → Publish

Können als einzelne Module oder Pipelines genutzt werden
