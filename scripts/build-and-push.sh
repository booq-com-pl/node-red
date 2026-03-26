#!/usr/bin/env bash
set -euo pipefail

REGISTRY="ghcr.io"
ORG="booq-com-pl"
IMAGE_NAME="node-red"
LOCAL_TAG="booq-node-red"
FULL_IMAGE="${REGISTRY}/${ORG}/${IMAGE_NAME}"
PLATFORM="linux/amd64"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

echo "==> Budowanie obrazu: ${LOCAL_TAG} (${PLATFORM})"
docker buildx build \
  --platform "${PLATFORM}" \
  --tag "${LOCAL_TAG}" \
  --tag "${FULL_IMAGE}:latest" \
  --load \
  "${PROJECT_DIR}"

echo ""
echo "==> Logowanie do ${REGISTRY}"
read -rp "Login (GitHub username): " GH_USER
read -rsp "Hasło (GitHub Personal Access Token): " GH_TOKEN
echo ""

echo "${GH_TOKEN}" | docker login "${REGISTRY}" --username "${GH_USER}" --password-stdin

echo ""
echo "==> Wypychanie obrazu: ${FULL_IMAGE}:latest"
docker push "${FULL_IMAGE}:latest"

echo ""
echo "==> Wylogowanie z ${REGISTRY}"
docker logout "${REGISTRY}"

echo ""
echo "Gotowe. Obraz dostępny pod: ${FULL_IMAGE}:latest"
