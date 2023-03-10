FROM fedora:latest

COPY fedora.sh /tmp

RUN dnf update --assumeyes && \
    sh /tmp/fedora.sh && \
    mkdir /builds

WORKDIR /builds

VOLUME [ "/builds" ]