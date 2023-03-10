FROM i386/ubuntu:bionic

ENV ARCH=i386 DIST=bionic CI=1

COPY ./install-deps.sh /
RUN bash -xe install-deps.sh

# create unprivileged user for non-build-script use of this image
# build-in-docker.sh will likely not use this one, as it enforces the caller's uid inside the container
RUN adduser --system --group build
USER build