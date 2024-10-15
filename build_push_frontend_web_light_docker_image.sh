#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Treat unset variables as an error
set -u

echo "Starting cleanup..."
# call ./cleanup.sh to remove all images and containers
./cleanup.sh
echo "Cleanup completed."

echo "Building tq-frontend-web-light image..."
# build tq-frontend-web-light image
docker build -f tq_frontend/qtwasm_multistage_Dockerfile -t tq-frontend-web-light .
echo "Image build completed."

# Docker login
if [ -z "${DOCKER_USERNAME:-}" ] || [ -z "${DOCKER_PASSWORD:-}" ]; then
  echo "DOCKER_USERNAME and DOCKER_PASSWORD must be set"
  exit 1
fi
echo "Logging into Docker..."
echo $DOCKER_PASSWORD | docker login --username $DOCKER_USERNAME --password-stdin
echo "Docker login successful."

echo "Tagging and pushing the image to Docker Hub..."
# push above to docker hub
docker tag tq-frontend-web-light:latest  $DOCKER_USERNAME/tq-frontend-web-light:latest
docker push $DOCKER_USERNAME/tq-frontend-web-light:latest
echo "Image pushed to Docker Hub successfully."
