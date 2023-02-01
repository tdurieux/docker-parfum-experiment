# Build
FROM golang:1.18.3-alpine AS build-env
RUN go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest

# Release