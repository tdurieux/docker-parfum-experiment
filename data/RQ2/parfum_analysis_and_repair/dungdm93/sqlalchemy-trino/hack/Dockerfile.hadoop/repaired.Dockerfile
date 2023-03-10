FROM alpine:3.10 AS downloader

WORKDIR /build
RUN apk add --no-cache -U curl gnupg tar

# Main Apache distributions:
#   * https://apache.org/dist
#   * https://archive.apache.org/dist
#   * https://dist.apache.org/repos/dist/release
# List all Apache mirrors:
#   * https://apache.org/mirrors
ARG APACHE_DIST=https://archive.apache.org/dist
ARG APACHE_MIRROR=${APACHE_DIST}
ARG HADOOP_VERSION=3.3.0

RUN set -eux; \
    curl -f -L "${APACHE_DIST}/hadoop/common/KEYS" | gpg --batch --import -; \
    curl -f -LO "${APACHE_MIRROR}/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz"; \
    curl -f -L "${APACHE_DIST}/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz.asc" \
           | gpg --batch --verify - "hadoop-${HADOOP_VERSION}.tar.gz";
RUN tar -xf  "hadoop-${HADOOP_VERSION}.tar.gz" --no-same-owner \
        --exclude="hadoop-*/share/doc"; rm "hadoop-${HADOOP_VERSION}.tar.gz" \
    mv       "hadoop-${HADOOP_VERSION}" "hadoop";



FROM  ubuntu:focal
LABEL maintainer="Dũng Đặng Minh <dungdm93@live.com>"
SHELL [ "/bin/bash", "-c" ]

RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        openjdk-8-jre-headless ca-certificates libc6 \
        libbz2-1.0 liblz4-1 libsnappy1v5 zlib1g libzstd1 \
        libssl1.1 libisal2 libnss3 libpam-modules krb5-user procps; \
    ln -s libcrypto.so.1.1 /usr/lib/x86_64-linux-gnu/libcrypto.so; \
    ln -s libssl.so.1.1    /usr/lib/x86_64-linux-gnu/libssl.so;    \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*

# TODO: Native Hadoop Library
# > hadoop checknative -a
# * libbz2-1.0 liblz4-1 libsnappy1v5 zlib1g libzstd1
# * libssl1.1
#   ln -s libcrypto.so.1.1 /usr/lib/x86_64-linux-gnu/libcrypto.so
#   ln -s libssl.so.1.1    /usr/lib/x86_64-linux-gnu/libssl.so
# * libisal2
#   ln -s libisal.so.2     /usr/lib/x86_64-linux-gnu/libisal.so

ENV JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64" \
    HADOOP_HOME="/opt/hadoop"

COPY --from=downloader "/build/hadoop" "${HADOOP_HOME}"

ENV PATH="${HADOOP_HOME}/bin:${PATH}" \
    LD_LIBRARY_PATH="${HADOOP_HOME}/lib/native:${LD_LIBRARY_PATH}"
