# Mastering Docker for Software Developers
Module 5 : Exam Week-1 - Assignment


## Overview
The topics I explain here are given below:
 - Single-stage build
    - [Explain Dockerfile](#explain-dockerfile)
    - [How to run Dockerfile?](#how-to-run-dockerfile)
 - Multi-stage build
    - [Explain multistage.Dockerfile](#explain-multistagedockerfile)
    - [How to run multistage.Dockerfile?](#how-to-run-multistagedockerfile)
 - [Single-stage vs Multi-stage size difference](#single-stage-vs-multi-stage-size-difference)
 

## Single-stage build

#### Explain Dockerfile
- Create a file name - `Dockerfile` 
- `# syntax=docker/dockerfile:1` which always points to the latest stable release of the version 1 docker syntax (optional).
- Defines build-time arguments for the versions of Go and Alpine Linux (optional). So that we can use the same version in the base image.
    ```dockerfile
    ARG GO_VERSION=1.22 \
        ALPINE_VERSION=3.19
   ```
- `FROM golang:${GO_VERSION}-alpine${ALPINE_VERSION}` - I used Golang official image with included Alpine Linux of the specified version which define in ARG. Use Alpine Linux because it is a bare-bones OS.
- `FROM golang:${GO_VERSION}-alpine${ALPINE_VERSION}` - I used Golang official image with included Alpine Linux of the specified version which define in ARG. Use Alpine Linux because it is a bare-bones OS.
- `LABEL version=1.0.0` - Adds a label to the Docker image with the version information (optional).
- `WORKDIR /home/go_server` - Sets the working directory inside the Docker container. This is where commands will be executed.
- `COPY go.mod go.sum ./` - Copies the go.mod and go.sum files from the host machine to the working directory in the container. Which is dependency management for Go projects.
- `RUN go mod download` - Downloads all dependencies.
- `COPY . .` - Copies all files source code of the Go application from the host machine current directory to the working directory in the container.
- Set environment variables as mentioned.
    ```dockerfile
    ENV CGO_ENABLED=0 \
        GOOS=linux \
        PORT=8465
    ```
- `RUN go build .` - Builds application in the current directory. Which builds a binary name **docker-gs-ping.exe** .
- `CMD ["./docker-gs-ping"]` - Run the binary using the default command to run when Docker container will start.

#### How to run Dockerfile?
- Open terminal in project directory
- Build the image using unique tag name to prevent conflict with Docker Hub.
    ```bash
    docker build -t mnk/go_server .
    ```
- Run that image. Here **--rm** flag ensure to remove the container when stoped, **-it** flag allow you to interact and **-p** flag for port binding `<host port>:<container port>`.
    ```bash
    docker run --rm -it -p 8465:8465 mnk/go_server
    ```
- Open the link with port number on browser.
    ```bash
    http://localhost:8465/
    ```




## Multi-stage build

#### Explain multistage.Dockerfile
- Create a file name - `multistage.Dockerfile` 
- Do all the necessary steps during the build which mention in Single-stage build except **set the PORT in ENV and run the binary**.
- `FROM alpine:${ALPINE_VERSION} as production` - We don't need Golang image to run the binary. To reduce the image size use Alpine Linux of the specified version which is defined in ARG as the base image. Also, specify stage name for the both first and second stages as build & production.
- `WORKDIR /home/go_server` - Sets the working directory inside the Docker container. This is where commands will be executed.
- `COPY --from=build /home/go_server/docker-gs-ping .` - Copy only **docker-gs-ping.exe** binary from **build stage** to **production stage** as we don't need other files.
- `ENV PORT=8465` - Specify the port on which the Go application will listen.
- `CMD ["./docker-gs-ping"]` - Run the binary using the default command to run when Docker container will start.

#### How to run multistage.Dockerfile?
- Open terminal in project directory
- Build the image using unique tag name to prevent conflict with Docker Hub. Here **--file** flag specifies the filename of the Dockerfile to build image.
    ```bash
    docker build -t mnk/go_server_multi . --file multistage.Dockerfile
    ```
- Run that image. Here **--rm** flag ensure to remove the container when stoped, **-it** flag allow you to interact and **-p** flag for port binding `<host port>:<container port>`.
    ```bash
    docker run --rm -it -p 8465:8465 mnk/go_server_multi
    ```
- Open the link with port number on browser.
    ```bash
    http://localhost:8465/
    ```



## Single-stage vs Multi-stage size difference
|  | Size(MB) |
| --- | --- |
| **Single-stage** | 408.48  |
| **Multi-stage**  | 15.52  |
| Size Difference | 392.96 |

In the multi-stage build, After building GO application binary, removed the Golang image and unnecessary files, resulting in a significantly smaller final image compared to the single-stage build. This size reduction is important for production servers.
