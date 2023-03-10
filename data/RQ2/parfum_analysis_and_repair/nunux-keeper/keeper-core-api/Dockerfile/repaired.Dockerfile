# Nunux Keeper core API server.
#
# VERSION 2.0

FROM node:6-onbuild

MAINTAINER Nicolas Carlier <https://github.com/ncarlier>

# Create storage directory
RUN bash -c 'mkdir -p /var/opt/app/storage/{upload,exports}'

# Ports