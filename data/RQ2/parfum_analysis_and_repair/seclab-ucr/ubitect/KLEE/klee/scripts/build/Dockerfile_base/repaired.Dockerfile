# Build dependencies for LLVM
FROM ubuntu:16.04
LABEL maintainer="Martin Nowack <m.nowack@imperial.ac.uk>"

ENV DOCKER_BUILD=1

# Define all variables that can be changed as argument to docker build
ARG BASE=/tmp

# Copy across all source files
ADD /scripts/build/* scripts/build/

# Install packages