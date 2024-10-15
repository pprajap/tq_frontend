#!/bin/bash

echo "Building tq-frontend-web-light image..."
# build tq-frontend-web-light image
docker build -f qtwasm_multistage_Dockerfile -t tq-frontend-web-light .
echo "Image build completed."
