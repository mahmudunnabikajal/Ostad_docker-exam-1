# syntax=docker/dockerfile:1

# Stage 1 - Builder

FROM golang:1.22-alpine3.19 as build

# Set working directory
WORKDIR /home/go_server

# Download all dependencies
COPY go.mod go.sum ./
RUN go mod download

# Copy all files
COPY . .

# Set environment variables as mention
ENV CGO_ENABLED=0 \
    GOOS=linux

# Build the application binary
RUN go build .




# Stage 2 - production

FROM alpine:3.19 as production
LABEL version=1.0.0

# Set working directory
WORKDIR /home/go_server

# Copy binary from build stage
COPY --from=build /home/go_server/docker-gs-ping .

# Set environment variables
ENV PORT=8465

# Run the binary
CMD ["./docker-gs-ping"]