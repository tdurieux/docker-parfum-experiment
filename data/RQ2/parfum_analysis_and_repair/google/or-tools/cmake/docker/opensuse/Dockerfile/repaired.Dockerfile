# Create a virtual environment with all tools installed
# ref: https://hub.docker.com/r/opensuse/tumbleweed
FROM opensuse/tumbleweed AS base
LABEL maintainer="corentinl@google.com"
# Install system build dependencies