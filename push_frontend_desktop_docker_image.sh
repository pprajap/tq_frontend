#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Treat unset variables as an error
set -u

echo "Building tq-frontend-desktop image..."
./build_frontend_desktop_docker_image.sh
echo "Image build completed."

# Docker login
docker login
echo "Docker login successful."

# fetch user name from docker login
export DOCKER_USERNAME=$(docker info | grep Username | awk '{print $2}')

echo "Tagging and pushing the image to Docker Hub..."
# push above to docker hub
docker tag tq-frontend-desktop:latest  $DOCKER_USERNAME/tq-frontend-desktop:latest
docker push $DOCKER_USERNAME/tq-frontend-desktop:latest
echo "Image pushed to Docker Hub successfully."
