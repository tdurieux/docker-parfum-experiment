FROM archlinux:base

COPY arch.sh /tmp

RUN pacman --sync --refresh --sysupgrade --noconfirm && \
    sh /tmp/arch.sh && \
    mkdir /builds

WORKDIR /builds

VOLUME [ "/builds" ]