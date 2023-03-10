FROM registry.fedoraproject.org/fedora:latest

VOLUME /srv/bootupd

WORKDIR /srv/bootupd

RUN dnf update -y && \
    dnf install -y make cargo rust glib2-devel openssl-devel ostree-devel && \
    dnf clean all