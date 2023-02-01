FROM golang:1.17 as go

COPY choose /choose

COPY rproxy /rproxy

RUN \
    apt-get update && \
    apt-get install --no-install-recommends -y upx-ucl && \
    cd /choose && \
    GOOS=linux GOARCH=amd64 go build -ldflags="-s -w" && \
    upx /choose/choose && \
    cd /rproxy && \
    GOOS=linux GOARCH=amd64 go build -ldflags="-s -w" && \
    upx /rproxy/rproxy && rm -rf /var/lib/apt/lists/*;

FROM ubuntu:18.04

COPY --from=go /choose/choose /usr/local/bin/
COPY --from=go /rproxy/rproxy /usr/local/bin/

RUN \
    apt update && \
    apt -y --no-install-recommends install xvfb x11-utils x11vnc tigervnc-common tigervnc-viewer && rm -rf /var/lib/apt/lists/*;

COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]

