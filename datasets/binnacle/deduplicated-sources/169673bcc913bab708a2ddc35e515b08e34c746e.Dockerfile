# VERSION:        0.1
# DESCRIPTION:    Create chromium container with its dependencies
# AUTHOR:         Jessica Frazelle <jess@docker.com>
# COMMENTS:
#   This file describes how to build a Chromium container with all
#   dependencies installed. It uses native X11 unix socket.
#   Tested on Debian Jessie
# USAGE:
#   # Download Chromium Dockerfile
#   wget http://raw.githubusercontent.com/jfrazelle/dockerfiles/master/chromium/Dockerfile
#
#   # Build chromium image
#   docker build -t chromium .
#
#   # Run stateful data-on-host chromium. For ephemeral, remove -v /data/chromium:/data
#   docker run -v /data/chromium:/data -v /tmp/.X11-unix:/tmp/.X11-unix \
#   -e DISPLAY=unix$DISPLAY chromium

#   # To run stateful dockerized data containers
#   docker run --volumes-from chromium-data -v /tmp/.X11-unix:/tmp/.X11-unix \
#   -e DISPLAY=unix$DISPLAY chromium

# Base docker image
FROM debian:jessie
MAINTAINER Jessica Frazelle <jess@docker.com>

COPY google-talkplugin_current_amd64.deb /src/google-talkplugin_current_amd64.deb
# Install Chromium
RUN sed -i.bak 's/jessie main/jessie main contrib non-free/g' /etc/apt/sources.list && \
    apt-get update && apt-get install -y \
    chromium \
    chromium-l10n \
    libcanberra-gtk-module \
    libexif-dev \
    libpango1.0-0 \
    libv4l-0 \
    pepperflashplugin-nonfree \
    --no-install-recommends && \
    mkdir -p /etc/chromium.d/ && \
    /bin/echo -e 'export GOOGLE_API_KEY="AIzaSyCkfPOPZXDKNn8hhgu3JrA62wIgC93d44k"\nexport GOOGLE_DEFAULT_CLIENT_ID="811574891467.apps.googleusercontent.com"\nexport GOOGLE_DEFAULT_CLIENT_SECRET="kdloedMFGdGla2P1zacGjAQh"' > /etc/chromium.d/googleapikeys && \
    dpkg -i '/src/google-talkplugin_current_amd64.deb'

# Autorun x11vnc
CMD ["/usr/bin/chromium", "--no-sandbox", "--user-data-dir=/data"]
