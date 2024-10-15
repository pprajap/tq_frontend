#!/bin/bash

echo "Building tq-frontend-desktop image..."
# build tq-frontend-desktop image
docker build -f qtdeskDockerfile -t tq-frontend-desktop .
echo "Image build completed."
