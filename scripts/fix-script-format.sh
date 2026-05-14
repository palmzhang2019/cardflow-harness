#!/usr/bin/env bash
set -euo pipefail

find .cardflow-harness/scripts -type f \( -name "*.sh" -o -name "*.py" \) -print0 \
  | xargs -0 sed -i 's/\r$//'

find .cardflow-harness/scripts -name "*:Zone.Identifier" -delete
find .cardflow-harness -name "*:Zone.Identifier" -delete

chmod +x .cardflow-harness/scripts/*.sh
chmod +x .cardflow-harness/scripts/*.py

echo "OK: fixed script line endings, permissions, and Zone.Identifier files."
