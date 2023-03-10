# Dockerfile to create a Mendix Docker image based on either the source code or
# Mendix Deployment Archive (aka mda file)
FROM ubuntu:bionic
#This version does a full build originating from the Ubuntu Docker images
LABEL Author="Mendix Digital Ecosystems"
LABEL maintainer="digitalecosystems@mendix.com"

# When doing a full build: install dependencies & remove package lists
RUN apt-get -q -y update && \
 DEBIAN_FRONTEND=noninteractive apt-get upgrade -q -y && \
 DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -q -y wget curl unzip libpq5 locales python3 python3-distutils libssl1.0.0 libgdiplus nginx-light libnginx-mod-stream binutils && \
 rm -rf /var/lib/apt/lists/* && \
 apt-get clean

# Set the locale to UTF-8 (needed for proper python3 functioning)
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

# Set nginx permissions
RUN touch /run/nginx.pid && \
    chown -R 1001:0 /var/log/nginx /var/lib/nginx /run/nginx.pid &&\
    chmod -R g=u /var/log/nginx /var/lib/nginx /run/nginx.pid

# Set python alias to python3 (required for Datadog)
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 1

