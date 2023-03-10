FROM arm32v7/ubuntu:xenial

ENV ARCH=armhf DIST=xenial

# inherited by build scripts
ARG VERBOSE=0

COPY ./install-deps-ubuntu.sh /
RUN bash -x /install-deps-ubuntu.sh

COPY ./install-cmake.sh /
RUN bash -x /install-cmake.sh

# create unprivileged user for non-build-script use of this image
# build-in-docker.sh will likely not use this one, as it enforces the caller's uid inside the container
RUN adduser --system --group build
USER build