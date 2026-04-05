#!/usr/bin/env bash
set -euo pipefail

BACKUP_FILE="${1:-}"

if [[ -z "${BACKUP_FILE}" ]]; then
  echo "Usage: $0 <path-to-backup.tar.gz>"
  exit 1
fi

if [[ ! -f "${BACKUP_FILE}" ]]; then
  echo "Error: file not found: ${BACKUP_FILE}"
  exit 1
fi

BACKUP_DIR="$(cd "$(dirname "${BACKUP_FILE}")" && pwd)"
BACKUP_NAME="$(basename "${BACKUP_FILE}")"

echo "==> Stopping node-red"
docker-compose stop node-red

echo "==> Restoring from: ${BACKUP_FILE}"
docker run --rm \
  -v node-red_node-red-data:/data \
  -v "${BACKUP_DIR}:/backup:ro" \
  alpine sh -c "rm -rf /data/* && tar xzf /backup/${BACKUP_NAME} -C / --strip-components=1"

echo "==> Starting node-red"
docker-compose start node-red

echo "Done. Restored from: ${BACKUP_FILE}"
