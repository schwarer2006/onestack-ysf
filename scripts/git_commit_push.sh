#!/bin/bash
# ──────────────────────────────────────────────────────
# 💾 Git Commit & Push Script
# 📦 Für OneStack-Projekte
# 🧑 Benutzer: $(whoami)
# 🕒 Erstellt: $(date +%F)
# ✨ Status: Stable
# 🔐 Sicherheit: Benutzer muss Schreibrechte haben
# ──────────────────────────────────────────────────────

echo "📂 Aktuelles Verzeichnis: $(pwd)"

# Optionales Git Pull zuerst
read -p "🔄 Vorher git pull ausführen? (y/n): " DO_PULL
if [[ "$DO_PULL" == "y" ]]; then
    git pull --no-rebase
    echo "✅ Pull abgeschlossen"
fi

# Dateien zum Commit prüfen
echo "📋 Git Status:"
git status

read -p "📌 Commit-Message eingeben: " COMMIT_MSG
if [[ -z "$COMMIT_MSG" ]]; then
  echo "⛔ Keine Commit-Nachricht angegeben. Abbruch."
  exit 1
fi

# Änderungen stagen, committen und pushen
git add .
git commit -m "$COMMIT_MSG"
git push

echo "✅ Git Push abgeschlossen."
