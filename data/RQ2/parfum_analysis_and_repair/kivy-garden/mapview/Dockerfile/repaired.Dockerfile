# Docker image for installing dependencies on Linux and running tests.
# Build with:
# docker build --tag=mapview-linux .
# Run with:
# docker run mapview-linux /bin/sh -c 'tox'
# Or for interactive shell:
# docker run -it --rm mapview-linux
# For using the UI from Docker you may need to:
# xhost +local:
FROM ubuntu:18.04

# install system dependencies