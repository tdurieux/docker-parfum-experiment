FROM arm64v8/alpine

ENV RCLONE_VER=1.49.5 \
    BUILD_DATE=20191026T002433 \
    QEMU_ARCH=aarch64 \
    ARCH=arm64 \
    SUBCMD="" \
    CONFIG="--config /config/rclone.conf" \
    PARAMS=""

LABEL build_version="Version:- ${RCLONE_VER} Build-date:- ${BUILD_DATE}"
LABEL maintainer="Lucas Halbert <lhalbert@lhalbert.xyz>"
MAINTAINER Lucas Halbert <lhalbert@lhalbert.xyz>

# COPY static qemu binary for cross-platform support
COPY qemu-${QEMU_ARCH}-static /usr/bin/

RUN apk add --no-cache --update ca-certificates fuse fuse-dev unzip curl mdocml-apropos curl-doc && \
    curl -f -O https://downloads.rclone.org/v${RCLONE_VER}/rclone-v${RCLONE_VER}-linux-${ARCH}.zip && \
    unzip rclone-v${RCLONE_VER}-linux-${ARCH}.zip && \
    cd rclone-*-linux-${ARCH} && \
    cp rclone /usr/bin/ && \
    chown root:root /usr/bin/rclone && \
    chmod 755 /usr/bin/rclone && \
    mkdir -p /usr/share/man/man1 && \
    cp rclone.1 /usr/share/man/man1/ && \
    makewhatis /usr/share/man && \
    apk del --purge unzip curl && \
    cd ../ && \
    rm -f rclone-v${RCLONE_VER}-linux-${ARCH}.zip && \
    rm -r rclone-*-linux-${ARCH}

#  Delete static qemu binary
RUN rm -f /usr/bin/qemu-${QEMU_ARCH}-static

COPY docker-entrypoint.sh /usr/bin/


ENTRYPOINT ["docker-entrypoint.sh"]
