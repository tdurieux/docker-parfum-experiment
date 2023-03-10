FROM ubuntu:latest

# Source build packages locally
ARG DOCKER_BUILD_PROXY
ENV DOCKER_BUILD_PROXY $DOCKER_BUILD_PROXY
ENV DEBIAN_FRONTEND noninteractive

# Install common build tools
RUN set -uex; \
    export http_proxy=${HTTP_PROXY-${DOCKER_BUILD_PROXY}}; \
    apt-get update; \
    apt-get install --no-install-suggests --no-install-recommends -y \
      build-essential \
      debhelper \
      dpkg-dev \
      mono-devel \
      libappindicator0.1-cil-dev \
      ca-certificates-mono \
      gtk-sharp2 \
      nuget; rm -rf /var/lib/apt/lists/*; \
    apt-get clean all

RUN nuget update -self

label org.label-schema.name = "duplicati/debian-build" \
      org.label-schema.version = "20161230" \
      org.label-schema.vendor="Deployable" \
      org.label-schema.docker.cmd="docker run -ti duplicati/debian-build" \
      org.label-schema.schema-version="1.0"