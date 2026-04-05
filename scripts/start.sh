#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

cd "${PROJECT_DIR}"

echo "==> Starting node-red"
docker compose up -d

echo "==> Node-RED is running at http://localhost:1880"
