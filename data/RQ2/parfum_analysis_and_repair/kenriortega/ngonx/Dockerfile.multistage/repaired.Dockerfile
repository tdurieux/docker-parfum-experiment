# Dockerfile References: https://docs.docker.com/engine/reference/builder/

# Start from the latest golang base image
FROM golang:1.16-alpine as builder

# Add Maintainer Info
LABEL maintainer="Kenrique Ortega <kenriortega@gmail.com>"

# Set the Current Working Directory inside the container
WORKDIR /app

# Copy go mod and sum files
COPY go.mod go.sum ./

# Download all dependencies. Dependencies will be cached if the go.mod and go.sum files are not changed
RUN go mod download

# Copy the source from the current directory to the Working Directory inside the container
COPY . .

# Build the Go app
RUN go build -ldflags "-s -w"  -o /app/ngonx cmd/main.go

######## Start a new stage from scratch #######
FROM alpine:latest

RUN apk --no-cache add ca-certificates

# Build Args
ARG APP_DIR=/app

# Create APP Directory
RUN mkdir -p ${APP_DIR}

WORKDIR /app/

# Copy the Pre-built binary file from the previous stage
COPY --from=builder /app/ngonx .
COPY --from=builder /app/ngonx.yaml .

# Expose port 8080 to the outside world
EXPOSE 8080

# Declare volumes to mount
VOLUME [${APP_DIR}]

# Command to run the executable