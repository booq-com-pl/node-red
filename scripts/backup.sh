#!/usr/bin/env bash
set -euo pipefail

BACKUP_DIR="${1:-/backups/node-red}"
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="${BACKUP_DIR}/node-red-${DATE}.tar.gz"
RETENTION_DAYS=7

mkdir -p "${BACKUP_DIR}"

echo "==> Creating backup: ${BACKUP_FILE}"
docker run --rm \
  -v node-red_node-red-data:/data:ro \
  -v "${BACKUP_DIR}:/backup" \
  alpine tar czf "/backup/node-red-${DATE}.tar.gz" /data

echo "==> Removing backups older than ${RETENTION_DAYS} days"
find "${BACKUP_DIR}" -name "*.tar.gz" -mtime "+${RETENTION_DAYS}" -delete

echo "Done. Backup saved: ${BACKUP_FILE}"
