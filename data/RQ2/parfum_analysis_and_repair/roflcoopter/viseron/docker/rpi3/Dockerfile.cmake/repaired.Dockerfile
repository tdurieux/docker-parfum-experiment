# No CI setup for this image, build locally
ARG UBUNTU_VERSION
FROM balenalib/raspberrypi3-ubuntu:${UBUNTU_VERSION}-build as build
RUN [ "cross-build-start" ]
ENV DEBIAN_FRONTEND=noninteractive

ARG MAKEFLAGS="-j2"
ARG CMAKE_VERSION

## Some libraries fail to compile using the distributed CMake
## Recompiling CMake with the below flags fixes this
## Related to https://gitlab.kitware.com/cmake/cmake/-/issues/20568