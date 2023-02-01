# Use a multi-stage build
FROM golang:latest AS builder

# Compile Go into exe
WORKDIR /app
COPY . ./
RUN CGO_ENABLED=0 GOOS=js GOARCH=wasm go build -ldflags="-s -w" -a -o ./qpsimplewasm.wasm .

FROM nginx:alpine

# Copy exe from build container