# This Zulu OpenJDK Dockerfile and corresponding Docker image are
# to be used solely with Java applications or Java application components
# that are being developed for deployment on Microsoft Azure or Azure Stack,
# and are not intended to be used for any other purpose.

FROM alpine
MAINTAINER Zulu Enterprise Container Images <azul-zulu-images@microsoft.com>

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN ZULU_PACK=zulu-7-azure-jre-headless_7.24.0.2-7.0.191-linux_x64.tar.gz && \
    INSTALL_DIR=/usr/lib/jvm && \
    BIN_DIR=/usr/bin && \
    MAN_DIR=/usr/share/man/man1 && \
    ZULU_DIR=$( basename ${ZULU_PACK} .tar.gz ) && \
    apk --no-cache add ca-certificates wget binutils && \
    wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.28-r0/glibc-2.28-r0.apk && \
    apk add --no-cache glibc-2.28-r0.apk && rm glibc-2.28-r0.apk && \
    wget -O gcc-libs.tar.xz https://www.archlinux.org/packages/core/x86_64/gcc-libs/download/ && \
    wget -O zlib.tar.xz https://www.archlinux.org/packages/core/x86_64/zlib/download/ && \
    tar -xJf gcc-libs.tar.xz -C /tmp usr/lib && \
    tar -xJf zlib.tar.xz -C /tmp usr/lib && \
    mv /tmp/usr/lib/libgcc_s.so* /tmp/usr/lib/libstdc++.so* /tmp/usr/lib/libz.so* /usr/glibc-compat/lib/ && \
    strip /usr/glibc-compat/lib/libgcc_s.so.* /usr/glibc-compat/lib/libstdc++.so.* && \
    rm -rf gcc-libs.tar.xz zlib.tar.xz /tmp/usr && \
    wget -q https://repos.azul.com/azure-only/zulu/packages/zulu-7/7u191/${ZULU_PACK} && \
    rm /root/.wget-hsts && \
    mkdir -p ${INSTALL_DIR} && \
    tar -xf ./${ZULU_PACK} -C ${INSTALL_DIR} && rm -f ${ZULU_PACK} && \
    cd ${BIN_DIR} && \
    find ${INSTALL_DIR}/${ZULU_DIR}/bin -type f -perm -a=x -exec ln -s {} . \; && \
    mkdir -p ${MAN_DIR} && \
    cd ${MAN_DIR} && \
    find ${INSTALL_DIR}/${ZULU_DIR}/man/man1 -type f -name "*.1" -exec ln -s {} . \;

