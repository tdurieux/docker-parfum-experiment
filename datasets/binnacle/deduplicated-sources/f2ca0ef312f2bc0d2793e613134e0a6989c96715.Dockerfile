FROM ubuntu:18.04
# Update the image with the latest packages (recommended)
# and install missing packages

ENV DEBIAN_FRONTEND=noninteractive
ENV IRAP_VERSION=devel

LABEL iRAP.version="$IRAP_VERSION" maintainer="nuno.fonseca at gmail.com"

ADD ./build/irap_docker_setup.sh build
RUN bash build ubuntu $IRAP_VERSION light 

#ENTRYPOINT ["irap"]
