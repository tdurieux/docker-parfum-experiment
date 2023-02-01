#
# cunnie/sslip.io-nginx
#
# sslip.io nginx Dockerfile
#
# Dockerfile of an nginx server that serves the web
# pages of the sslip.io domain.
#
# Typical start command:
#
#   docker run --rm -p 8080:80 cunnie/sslip.io-nginx
#
# To test from host:
#
#    curl -I http://localhost:8080
#
FROM fedora AS sslip.io-nginx

LABEL org.opencontainers.image.authors="Brian Cunnie <brian.cunnie@gmail.com>"

RUN dnf install -y \
    bind-utils \
    iproute \
    less \
    lsof \
    neovim \
    net-tools \
    nginx \
    nmap-ncat \
    procps-ng

RUN mv /usr/share/nginx/html /usr/share/nginx/html-orig

COPY document_root_sslip.io /usr/share/nginx/html

ENTRYPOINT [ "/usr/sbin/nginx", "-g", "daemon off;" ]

# for testing:
# ENTRYPOINT /bin/bash

# nginx listens on port 80
# The `EXPOSE` directive doesn't do much in our case. We use it for documentation.