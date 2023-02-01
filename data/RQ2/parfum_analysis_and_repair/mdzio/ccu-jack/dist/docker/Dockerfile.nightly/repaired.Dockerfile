# Please don't use this filke directly but
# build the image with Shellscript "./build-nightly.sh"

# Start compile from golang alpine base image
FROM golang:alpine3.13 as builder
RUN apk --no-cache add unzip

# Set the Current Working Directory inside the container
WORKDIR /app

# Get the current source
RUN wget -q "https://github.com/mdzio/ccu-jack/archive/master.zip" && \
    unzip master.zip
RUN cd ccu-jack-master/build && go run .

######## Start a new stage from scratch and build the dist container #######
FROM alpine 

ARG BUILD_DATE
ARG BUILD_VERSION
ARG BUILD_VERSION_NIGHTLY

LABEL maintainer="Theta Gamma <thetagamma11@gmail.com>"
LABEL org.opencontainers.image.created=$BUILD_DATE \
      org.opencontainers.image.version=$BUILD_VERSION \
      org.opencontainers.image.title="CCU-Jack" \
      org.opencontainers.image.description="REST/MQTT-Server for the HomeMatic CCU" \
      org.opencontainers.image.vendor="CCU-Jack OpenSource Project" \
      org.opencontainers.image.authors="mdzio <info@ccu-historian.de>" \
      org.opencontainers.image.licenses="GPL-3.0 License" \
      org.opencontainers.image.url="https://github.com/mdzio/ccu-jack" \
      org.opencontainers.image.documentation="https://github.com/mdzio/ccu-jack/blob/master/README.md"

# Set work directory
WORKDIR /app

# Get the compiled binary and extract it locally
COPY --from=builder /app/ccu-jack-master/ccu-jack-linux-${BUILD_VERSION}.tar.gz .

RUN tar -xvzf ccu-jack-linux-${BUILD_VERSION}.tar.gz && \
    mkdir -p /app/conf /app/cert /data && \
    adduser -h /app -D -H ccu-jack -u 1000 -s /sbin/nologin && \
    chown -R ccu-jack:ccu-jack /data && chmod -R g+rwX /data && \
    chown -R ccu-jack:ccu-jack /app && chmod -R g+rwX /app &&\
    rm ccu-jack-linux*.tar.gz

USER ccu-jack

# MQTT, MQTT TLS, CCU-Jack VEAM/UI, CCU-Jack VEAM/UI TLS, CUxD
EXPOSE 1883 8883 2121 2122 2123

# Add a healthcheck (default every 30 secs)
HEALTHCHECK --interval=30s --timeout=5s --start-period=40s --retries=3 \
    CMD wget --spider -S -q http://localhost:2121/ui/ 2>&1 | head -1 || exit 1

# Start it up with full path