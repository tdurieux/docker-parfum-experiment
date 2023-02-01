# Dockerfile for gvm-libs-$COMPILER-build:$VERSION

# Define ARG we use through the build
ARG VERSION=unstable

# Use '-slim' image for reduced image size
FROM debian:stable-slim

# This will make apt-get install without question
ARG DEBIAN_FRONTEND=noninteractive

# Redefine ARG we use through the build
ARG COMPILER

WORKDIR /source

# Install core dependencies required for building and testing gvm-libs