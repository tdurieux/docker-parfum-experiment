FROM golang:1.17-bullseye AS golang-builder

RUN mkdir -p /opt/bitnami

ADD packages.sh /packages.sh
RUN chmod +x /packages.sh && \
    /packages.sh