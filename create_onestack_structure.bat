@echo off
REM ===========================================
REM OneStack YSF Setup Script für Windows (CMD)
REM Erstellt Projektstruktur inkl. leerer Dateien
REM Version: 0.1
REM ===========================================

set BASE=%CD%\onestack-ysf

echo 📁 Erstelle Basisverzeichnis: %BASE%
mkdir %BASE%
cd %BASE%

REM Core-Struktur
mkdir core\engine
echo. > core\cli.py
echo. > core\validator.py
echo. > core\engine\loader.py
echo. > core\engine\processor.py
echo. > core\engine\transformer.py
echo. > core\engine\publisher.py
echo. > core\engine\engine.meta
echo. > core\engine\README.md

REM Skripte
mkdir scripts
echo. > scripts\bootstrap.sh
echo. > scripts\install.sh
echo. > scripts\preflight_check.sh
echo. > scripts\setup.sh
echo. > scripts\update_engine_meta.py
echo. > scripts\import_testlog.py
echo. > scripts\script_meta.py

REM Gemeinsame Daten
mkdir shared
echo. > shared\dim_date.parquet

REM Speicher (DuckDB)
mkdir storage\duckdb\dev
mkdir storage\duckdb\qa
mkdir storage\duckdb\prod
mkdir storage\duckdb\system
echo. > storage\duckdb\system\onestack_meta.duckdb

REM Logs
mkdir logs\core
echo. > logs\cli.log
echo. > logs\test_results.log

REM Beispielprojekt
mkdir projects\prj-0001\config
mkdir projects\prj-0001\nodes\node-0001
mkdir projects\prj-0001\orchestration
mkdir projects\prj-0001\templates
mkdir projects\prj-0001\tests
mkdir projects\prj-0001\logs
echo. > projects\prj-0001\README.md

REM Konfigurationsdateien
echo. > config.yaml
echo. > .gitignore
echo. > CHANGELOG.md
echo. > README.md

echo ✅ OneStack YSF Struktur wurde erfolgreich erstellt.
pause
