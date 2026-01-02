#!/bin/bash

# Backup Script für AI Tierarzt Projekt
# Führt automatisch einen Git Commit durch

cd "/Users/blargou/Desktop/AI Tierarzt pro"

# Prüfe ob Git Repository existiert
if [ ! -d .git ]; then
    echo "❌ Git Repository nicht gefunden!"
    exit 1
fi

# Füge alle Änderungen hinzu
git add .

# Erstelle Commit mit Zeitstempel
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
git commit -m "Auto-backup: $TIMESTAMP" || echo "ℹ️ Keine Änderungen zum Committen"

echo "✅ Backup abgeschlossen: $TIMESTAMP"


