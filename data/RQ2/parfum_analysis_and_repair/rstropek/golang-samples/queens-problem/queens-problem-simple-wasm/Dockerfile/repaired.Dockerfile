# Use a multi-stage build
FROM golang:latest AS builder

# Install module for solving n queens problem
RUN go get github.com/rstropek/golang-samples/queens-problem/queens-problem-bitarray-solver

# Compile Go into exe
WORKDIR /app
COPY ./*.go ./
RUN CGO_ENABLED=0 GOOS=js GOARCH=wasm go build -ldflags="-s -w" -a -o ./qpsimplewasm.wasm .

FROM nginx:alpine

# Copy exe from build container