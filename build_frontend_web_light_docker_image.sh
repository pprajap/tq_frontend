#!/bin/bash

echo "Building tq-frontend-web-light image..."
# build tq-frontend-web-light image
docker build -f qtwebDockerfile -t tq-frontend-web-light .
echo "Image build completed."
