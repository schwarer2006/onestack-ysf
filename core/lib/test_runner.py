# core/lib/test_runner.py

#!/usr/bin/env python3
# ==========================================================
# 📄 Script: test_runner.py
# 🧠 Zweck : Führt YAML-Validierung durch (Struktur, Pflichtfelder)
#           und zeigt Ergebnisse in Farbtabelle via rich an
# 🔧 Version: 0.1.0
# ✏️ Status : stable
# 📅 Erstellt: 2025-04-11
# 🧪 Module: core/lib/test_runner.py
# ==========================================================


from rich.console import Console
from rich.table import Table
from datetime import datetime
import os
import yaml

console = Console()
LOG_FILE = "logs/test_results.log"

def test_all_yaml(args):
    def validate_yaml_file(filepath):
        try:
            with open(filepath, "r") as f:
                data = yaml.safe_load(f)
            if not isinstance(data, dict):
                return False, "Keine gültige YAML-Struktur (dict erwartet)"
            if "type" not in data or "name" not in data:
                return False, "Fehlender Schlüssel: 'type' oder 'name'"
            return True, "Valide"
        except Exception as e:
            return False, f"YAML-Fehler: {str(e)}"

    path = args.path if args.path else "projects"
    console.print(f"\n🧪 [bold]YAML-Testlauf gestartet in:[/bold] [blue]{path}[/blue]")

    table = Table(show_header=True, header_style="bold cyan")
    table.add_column("Datei", style="dim", min_width=35)
    table.add_column("Status")
    table.add_column("Nachricht")

    log_entries = []
    ok, warn, fail = 0, 0, 0

    for root, _, files in os.walk(path):
        for file in files:
            if file.endswith(".yaml") or file.endswith(".yml"):
                full_path = os.path.join(root, file)
                valid, msg = validate_yaml_file(full_path)

                if valid:
                    table.add_row(full_path, "[green]✅ OK[/green]", msg)
                    ok += 1
                else:
                    if "Fehlender Schlüssel" in msg:
                        table.add_row(full_path, "[yellow]⚠️ Hinweis[/yellow]", msg)
                        warn += 1
                    else:
                        table.add_row(full_path, "[red]❌ Fehler[/red]", msg)
                        fail += 1

                log_entries.append(f"{datetime.now().isoformat()} | {full_path} | {msg}")

    console.print()
    console.print(table)
    console.print(f"\n📊 [bold]Zusammenfassung:[/bold] ✅ {ok}, ⚠️ {warn}, ❌ {fail}")

    os.makedirs("logs", exist_ok=True)
    logfile = args.logfile if args.logfile else LOG_FILE
    with open(logfile, "a") as logf:
        for entry in log_entries:
            logf.write(entry + "\n")

    if getattr(args, "markdown_report", False):
        md_path = logfile.replace(".log", ".md")
        with open(md_path, "w") as md:
            md.write(f"# YAML Test Report – {datetime.now().isoformat()}\n\n")
            for entry in log_entries:
                md.write(f"- {entry}\n")
        console.print(f"\n📝 Markdown-Report gespeichert: [green]{md_path}[/green]")
