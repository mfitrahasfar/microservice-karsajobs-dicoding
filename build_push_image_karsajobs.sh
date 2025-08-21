#!/usr/bin/env bash
# build_push_image_karsajobs.sh
# ------------------------------------------------------------
# Script ini membangun dan push Docker image BACKEND ke GHCR.
# Komentar diberikan pada setiap langkah agar jelas maksudnya.
#
# Prasyarat env var yang harus tersedia:
#   GHCR_USER -> username GitHub Anda (contoh: YOUR_GHCR_USERNAME)
#   GHCR_PAT  -> GitHub Personal Access Token dengan scope "write:packages"
# ------------------------------------------------------------

# 'set -euo pipefail' memastikan script gagal segera bila ada kesalahan,
# variabel tak terdefinisi dianggap error (-u), dan pipe gagal terdeteksi (-o pipefail).
set -euo pipefail

# Nama/tag image yang akan dibuat. 'latest' dipakai untuk kemudahan tugas.
IMAGE="ghcr.io/${GHCR_USER}/karsajobs:latest"

echo "[1/3] Login ke GHCR..."
# Login ke registry ghcr.io dengan user + PAT via stdin agar tidak tersimpan di history shell.
echo -n "${GHCR_PAT}" | docker login ghcr.io -u "${GHCR_USER}" --password-stdin

echo "[2/3] Build image backend..."
# Build image dari Dockerfile di direktori saat ini (-f Dockerfile .).
# -t menetapkan nama + tag image sesuai variabel IMAGE.
docker build -t "${IMAGE}" -f Dockerfile .

echo "[3/3] Push image ke GHCR..."
# Dorong image yang sudah dibangun ke registry GHCR.
docker push "${IMAGE}"

# Tampilkan informasi akhir agar mudah mengecek namanya.
echo "Selesai. Image tersedia di: $IMAGE"
