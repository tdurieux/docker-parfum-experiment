# Create a virtual environment with all tools installed
# ref: https://hub.docker.com/_/alpine
FROM alpine:edge AS base
LABEL maintainer="corentinl@google.com"
# Install system build dependencies