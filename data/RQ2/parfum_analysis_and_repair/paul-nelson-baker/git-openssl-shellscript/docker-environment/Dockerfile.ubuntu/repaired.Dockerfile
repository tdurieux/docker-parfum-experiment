ARG UBUNTU_VERSION
FROM ubuntu:${UBUNTU_VERSION}
ARG UBUNTU_VERSION

ENV DEBIAN_FRONTEND=noninteractive
# RUN --mount=type=cache,id=ubuntu-${UBUNTU_VERSION}-cache,target=/var/cache/apt --mount=type=cache,id=ubuntu-${UBUNTU_VERSION}-lib,target=/var/lib/apt \
RUN apt-get update && \
  apt-get -y --no-install-recommends install sudo && rm -rf /var/lib/apt/lists/*;
# RUN --mount=type=cache,id=ubuntu-${UBUNTU_VERSION}-cache,target=/var/cache/apt --mount=type=cache,id=ubuntu-${UBUNTU_VERSION}-lib,target=/var/lib/apt \
RUN apt-get install --no-install-recommends build-essential autoconf dh-autoreconf libcurl4-openssl-dev \
    tcl-dev gettext asciidoc docbook2x install-info \
    libexpat1-dev libz-dev -y && rm -rf /var/lib/apt/lists/*;

RUN useradd --create-home git-user
RUN usermod -aG sudo git-user
RUN echo "%sudo ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER git-user
WORKDIR /home/git-user
ENTRYPOINT [ "/bin/bash", "-c" ]