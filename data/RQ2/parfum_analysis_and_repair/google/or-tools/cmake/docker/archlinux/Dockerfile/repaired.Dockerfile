# Create a virtual environment with all tools installed
# ref: https://hub.docker.com/_/archlinux/
FROM archlinux:latest AS base
LABEL maintainer="corentinl@google.com"
# Install system build dependencies