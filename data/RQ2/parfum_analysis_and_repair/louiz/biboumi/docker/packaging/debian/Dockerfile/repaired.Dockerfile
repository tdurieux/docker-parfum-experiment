# This Dockerfile creates a docker image suitable to build a debian package

FROM docker.io/debian:sid

RUN apt update && apt install --no-install-recommends -y \
    git \
    devscripts && rm -rf /var/lib/apt/lists/*; # Needed to build biboumi



