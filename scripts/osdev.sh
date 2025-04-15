#!/bin/bash
# Aktiviert die OneStack Entwicklungsumgebung

cd /opt/onestack-ysf || exit 1
source venv/onestack/bin/activate
export ONESTACK_MODE="dev"

echo "✅ OneStack venv aktiviert (dev)"
