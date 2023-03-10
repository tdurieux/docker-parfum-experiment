# Dockerfile for building an image with ubuntu bionic
ARG DIST=bionic
FROM sociomantictsunami/develbase:$DIST-v8

RUN export DEBIAN_FRONTEND=noninteractive

# delete all the apt list files to speed up 'apt-get update' command
RUN rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get -y install --no-install-recommends \
    libssl-dev autoconf libtool make automake zlib1g-dev api-sanity-checker && rm -rf /var/lib/apt/lists/*; # install required packages


