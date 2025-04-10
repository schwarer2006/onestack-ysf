 #!/usr/bin/env python3
# ==========================================================
# 📄 Script: script_meta.py
# 🧠 Zweck : Fügt Header in Python-Skripte ein (Entwicklerstandard)
# 🔧 Version: 0.1.0
# ✏️ Status : stable
# 📅 Erstellt: 2025-04-10
# ==========================================================

import os
import sys
from datetime import date

TEMPLATE = '''#!/usr/bin/env python3
# ==========================================================
# 📄 Script: {filename}
# 🧠 Zweck : {description}
# 🔧 Version: {version}
# ✏️ Status : {status}
# 📅 Erstellt: {created}
# ==========================================================

'''

def insert_header(filepath, description="(Beschreibung einfügen)", version="0.1.0", status="draft"):
    if not os.path.exists(filepath):
        print(f"❌ Datei nicht gefunden: {filepath}")
        return

    with open(filepath, "r") as f:
        content = f.read()

    if "📄 Script:" in content:
        print(f"⏭️  Header bereits vorhanden: {filepath}")
        return

    filename = os.path.basename(filepath)
    header = TEMPLATE.format(
        filename=filename,
        description=description,
        version=version,
        status=status,
        created=str(date.today())
    )

    with open(filepath, "w") as f:
        f.write(header + content)

    print(f"✅ Header eingefügt in: {filepath}")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("⚠️  Usage: script_meta.py <file.py> [Beschreibung]")
        exit(1)

    file = sys.argv[1]
    desc = sys.argv[2] if len(sys.argv) > 2 else "(Beschreibung einfügen)"
    insert_header(file, description=desc)

