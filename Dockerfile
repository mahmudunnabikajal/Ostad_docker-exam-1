# syntax=docker/dockerfile:1

FROM golang:1.22-alpine3.19 as build
LABEL version=1.0.0

# Set working directory
WORKDIR /home/go_server

# Download all dependencies
COPY go.mod go.sum ./
RUN go mod download

# Copy all files
COPY . .

# Set environment variables as mention
ENV CGO_ENABLED=0 \
    GOOS=linux \
    PORT=8465

# Build the application binary
RUN go build .

# Run the binary
CMD ["./docker-gs-ping"]