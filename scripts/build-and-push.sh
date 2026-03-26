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

GIT_SHA="$(git -C "${PROJECT_DIR}" rev-parse --short=8 HEAD)"

echo "==> Building image: ${LOCAL_TAG} (${PLATFORM}), SHA: ${GIT_SHA}"
docker buildx build \
  --platform "${PLATFORM}" \
  --tag "${LOCAL_TAG}" \
  --tag "${FULL_IMAGE}:latest" \
  --tag "${FULL_IMAGE}:${GIT_SHA}" \
  --load \
  "${PROJECT_DIR}"

echo ""
echo "==> Logging in to ${REGISTRY}"
read -rp "Login (GitHub username): " GH_USER
read -rsp "Password (GitHub Personal Access Token): " GH_TOKEN
echo ""

echo "${GH_TOKEN}" | docker login "${REGISTRY}" --username "${GH_USER}" --password-stdin

echo ""
echo "==> Pushing image: ${FULL_IMAGE}:latest and ${FULL_IMAGE}:${GIT_SHA}"
docker push "${FULL_IMAGE}:latest"
docker push "${FULL_IMAGE}:${GIT_SHA}"

echo ""
echo "==> Logging out from ${REGISTRY}"
docker logout "${REGISTRY}"

echo ""
echo "==> Updating image tag in kustomization.yaml to: ${GIT_SHA}"
K8S_DIR="${PROJECT_DIR}/k8s"
(cd "${K8S_DIR}" && kustomize edit set image "${FULL_IMAGE}:${GIT_SHA}")

echo ""
echo "==> Apply changes to the cluster? (kubectl apply -k k8s/) [y/N]"
read -rp "> " APPLY
if [[ "${APPLY}" =~ ^[tTyY]$ ]]; then
  kubectl apply -k "${K8S_DIR}"
  echo "Deployed."
else
  echo "Skipped. To deploy manually:"
  echo "  kubectl apply -k k8s/"
fi

echo ""
echo "Done. Image available at:"
echo "  ${FULL_IMAGE}:latest"
echo "  ${FULL_IMAGE}:${GIT_SHA}"
