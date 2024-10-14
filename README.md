# tq-frontend Project

# Build the Docker Image for Desktop

```sh
docker build -f qtdeskDockerfile -t tq-frontend-desktop .
```

# Run the Container and Mount the Current Directory to /app in the Container

```sh
xhost +local:docker
docker run -it --rm \
    -e DISPLAY=$DISPLAY \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    --device /dev/dri \
    -v $(pwd):/app \
    tq-frontend-desktop
```

# Build the Docker Image for Web

```sh
docker build -f qtwasmDockerfile -t tq-frontend-web .
```

# Run the Docker Container for Web

```sh
docker run -it --rm -p 3000:3000 tq-frontend-web
```


# Build the Docker Image for Web (Light Version without Qt WebAssembly Packages)

```sh
docker build -f qtwasm_multistage_Dockerfile -t tq-frontend-web-light .
```

# Run the Docker Container for Web (Light Version without Qt WebAssembly Packages)

```sh
docker run -it --rm -p 3000:3000 tq-frontend-web-light
```

**Comment:** Frontend service is running. Visit [http://localhost:3000/apptq_frontend.html](http://localhost:3000/apptq_frontend.html). Replace localhost with appropriate EXTERNAL_IP in case the frontend is deployed on cloud.

