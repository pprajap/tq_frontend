# tq-frontend Project
`tq-frontend` is a frontend application designed to work across different platforms including Linux, macOS, and Windows. The project leverages Docker to ensure consistent environments and easy deployment. This README provides instructions on building and running the Docker images for both desktop and web versions of the application.


## Table of Contents
- [tq-frontend Project](#tq-frontend-project)
  - [Table of Contents](#table-of-contents)
  - [1. Build the Docker Image for Desktop](#1-build-the-docker-image-for-desktop)
  - [2. Run the Container](#2-run-the-container)
    - [For Linux](#for-linux)
    - [For macOS](#for-macos)
    - [For Windows:](#for-windows)
  - [3. Build the Docker Image for Web](#3-build-the-docker-image-for-web)
  - [4. Run the Docker Container for Web](#4-run-the-docker-container-for-web)

## 1. Build the Docker Image for Desktop
```sh
docker build -f qtdeskDockerfile -t tq-frontend-desktop .
```

## 2. Run the Container
### For Linux
```sh
xhost +local:docker
docker run -it --rm \
    --env DISPLAY=${DISPLAY} \
    --volume /tmp/.X11-unix:/tmp/.X11-unix \
    --device /dev/dri:/dev/dri \
    tq-frontend-desktop
```
### For macOS
1. Install XQuartz: Download and install XQuartz from XQuartz.org.  
2. Open XQuartz: Go to Preferences > Security and check the box for "Allow connections from network clients".  
3. Restart XQuartz.  
4. Run the following command in the terminal:  
```sh
xhost +
docker run -it --rm \
    --env DISPLAY=host.docker.internal:0 \
    tq-frontend-desktop
```

### For Windows:
1. Install VcXsrv: Download and install VcXsrv from SourceForge.  
2. Open VcXsrv: Go with the default settings.  
3. Run the following command in the terminal:  
```sh
set DISPLAY=host.docker.internal:0
docker run -it --rm \
    --env DISPLAY=host.docker.internal:0 \
    tq-frontend-desktop
```

## 3. Build the Docker Image for Web
```sh
docker build -f qtwebDockerfile -t tq-frontend-web .
```

## 4. Run the Docker Container for Web
```sh
docker run --rm -p 3000:3000 -it tq-frontend-web
```
