FROM hypriot/rpi-alpine-scratch:edge

# Add support for cross-builds
COPY qemu-arm-static /usr/bin/

RUN apk add --no-cache --update nginx

COPY nginx.conf /etc/nginx/
COPY index.html data.json /usr/share/nginx/html/
