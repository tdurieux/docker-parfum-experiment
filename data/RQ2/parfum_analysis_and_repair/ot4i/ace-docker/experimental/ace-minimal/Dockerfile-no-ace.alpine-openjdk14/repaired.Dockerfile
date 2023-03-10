FROM alpine:3.14

# docker build -t alpine-openjdk14 -f Dockerfile-no-ace.alpine-openjdk14 .

MAINTAINER Trevor Dolby <tdolby@uk.ibm.com> (@tdolby)

ARG JDK_DOWNLOAD_URL=https://download.java.net/java/GA/jdk14.0.1/664493ef4a6946b186ff29eb326336a2/7/GPL/openjdk-14.0.1_linux-x64_bin.tar.gz
ARG JDK_LABEL=jdk-14.0.1


RUN apk --update add --no-cache --virtual .build-deps curl binutils zstd \
    && GLIBC_VER="2.31-r0" \
    && ALPINE_GLIBC_REPO="https://github.com/sgerrand/alpine-pkg-glibc/releases/download" \
    && GCC_LIBS_URL="https://archive.archlinux.org/packages/g/gcc-libs/gcc-libs-10.1.0-2-x86_64.pkg.tar.zst" \
    && GCC_LIBS_SHA256=f80320a03ff73e82271064e4f684cd58d7dbdb07aa06a2c4eea8e0f3c507c45c \
    && ZLIB_URL="https://archive.archlinux.org/packages/z/zlib/zlib-1%3A1.2.11-4-x86_64.pkg.tar.xz" \
    && ZLIB_SHA256=43a17987d348e0b395cb6e28d2ece65fb3b5a0fe433714762780d18c0451c149 \
    && curl -f -Ls https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub -o /etc/apk/keys/sgerrand.rsa.pub \
    && curl -f -Ls ${ALPINE_GLIBC_REPO}/${GLIBC_VER}/glibc-${GLIBC_VER}.apk > /tmp/${GLIBC_VER}.apk \
    && apk add /tmp/${GLIBC_VER}.apk \
    && curl -f -Ls ${GCC_LIBS_URL} -o /tmp/gcc-libs.tar.zst \
    && echo "${GCC_LIBS_SHA256}  /tmp/gcc-libs.tar.zst" | sha256sum -c - \
    && mkdir /tmp/gcc \
    && zstd -d /tmp/gcc-libs.tar.zst \
    && tar -xf /tmp/gcc-libs.tar -C /tmp/gcc \
    && mv /tmp/gcc/usr/lib/libgcc* /tmp/gcc/usr/lib/libstdc++* /usr/glibc-compat/lib \
    && strip /usr/glibc-compat/lib/libgcc_s.so.* /usr/glibc-compat/lib/libstdc++.so* \
    && curl -f -Ls ${ZLIB_URL} -o /tmp/libz.tar.xz \
    && echo "${ZLIB_SHA256}  /tmp/libz.tar.xz" | sha256sum -c - \
    && mkdir /tmp/libz \
    && tar -xf /tmp/libz.tar.xz -C /tmp/libz \
    && mv /tmp/libz/usr/lib/libz.so* /usr/glibc-compat/lib \
    && apk del --purge .build-deps \
    && rm -rf /tmp/${GLIBC_VER}.apk /tmp/gcc /tmp/gcc-libs.tar* /tmp/libz /tmp/libz.tar* /var/cache/apk/* \
    && mkdir /usr/glibc-compat/zlib-only \
    && ( cd /usr/glibc-compat/lib && tar -cf - libz* ) | ( cd /usr/glibc-compat/zlib-only && tar -xf - ) \
    && apk add --no-cache 'apk-tools>2.12.5-r1'

ENV TZ=Europe/London

# Set the env vars mentioned above
COPY profile-with-openjdk14-paths.sh /etc/profile.d/profile-with-openjdk14-paths.sh
COPY openjdk14-paths.sh /etc/profile.d/openjdk14-paths.sh


# Install openjdk
RUN mkdir -p /opt/ibm && \
    apk add --no-cache binutils zip bash curl && \
    cd /opt && \
    curl -f ${JDK_DOWNLOAD_URL} | tar -xzf - && \
    /opt/${JDK_LABEL}/bin/jlink --strip-debug --no-man-pages --no-header-files --output /opt/openjdk-14 --add-modules java.base,java.compiler,java.datatransfer,java.instrument,java.logging,java.management,java.management.rmi,java.naming,java.net.http,java.prefs,java.rmi,java.scripting,java.se,java.security.jgss,java.security.sasl,java.sql,java.sql.rowset,java.transaction.xa,java.xml,java.xml.crypto,jdk.accessibility,jdk.aot,jdk.attach,jdk.charsets,jdk.compiler,jdk.crypto.cryptoki,jdk.crypto.ec,jdk.dynalink,jdk.hotspot.agent,jdk.internal.ed,jdk.internal.jvmstat,jdk.internal.le,jdk.internal.opt,jdk.internal.vm.ci,jdk.internal.vm.compiler,jdk.internal.vm.compiler.management,jdk.jartool,jdk.jcmd,jdk.jconsole,jdk.jdeps,jdk.jdi,jdk.jdwp.agent,jdk.jfr,jdk.jlink,jdk.management,jdk.management.agent,jdk.management.jfr,jdk.naming.dns,jdk.naming.rmi,jdk.net,jdk.nio.mapmode,jdk.sctp,jdk.security.auth,jdk.security.jgss,jdk.unsupported,jdk.xml.dom,jdk.zipfs && \
    rm -rf /opt/${JDK_LABEL} && \
    apk del --purge binutils zip curl ncurses-terminfo-base ncurses-libs


RUN apk add --no-cache binutils zip bash curl && \
    addgroup mqbrkrs

# ln -s /opt/openjdk-14 /opt/ibm/ace-12/common/jdk/jre

# Create a user to run as, create the ace workdir, and chmod script files
RUN ( echo "Passw0rd" ; echo "Passw0rd" ) | adduser -h /home/aceuser -s /bin/bash aceuser mqbrkrs && \
    adduser aceuser mqbrkrs && \
    mkdir /var/mqsi && chmod 777 /var/mqsi

USER aceuser
ENTRYPOINT ["bash"]
