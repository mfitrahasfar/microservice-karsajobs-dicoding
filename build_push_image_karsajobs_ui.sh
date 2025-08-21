#!/usr/bin/env bash
# build_push_image_karsajobs_ui.sh
# ------------------------------------------------------------
# Membangun & push Docker image FRONTEND (Vue) ke GHCR.
# CATATAN:
# - Nilai backend di-embed saat build dari file .env
#   (contoh untuk port-forward: VUE_APP_BACKEND=http://localhost:8081)
# - Gunakan TAG versi agar Kubernetes menarik image terbaru (hindari latest).
# ------------------------------------------------------------

set -euo pipefail

: "${GHCR_USER:?Harus set GHCR_USER}"
: "${GHCR_PAT:?Harus set GHCR_PAT}"

# Tag bisa dikirim via argumen, default pakai timestamp (unik)
IMAGE_TAG="${1:-v$(date +%s)}"
IMAGE="ghcr.io/${GHCR_USER}/karsajobs-ui:${IMAGE_TAG}"

echo "[1/3] Login ke GHCR..."
echo -n "${GHCR_PAT}" | docker login ghcr.io -u "${GHCR_USER}" --password-stdin

echo "[2/3] Build image frontend dengan tag ${IMAGE_TAG}..."
docker build -t "${IMAGE}" -f Dockerfile .

echo "[3/3] Push image ke GHCR..."
docker push "${IMAGE}"

echo "Selesai. Image tersedia di: ${IMAGE}"
echo "👉 Pakai image ini di Deployment dan set imagePullPolicy: Always"
