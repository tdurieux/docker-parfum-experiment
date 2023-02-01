ARG HADOOP_VERSION=3.1.0

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
ARG HIVE_VERSION=3.1.2

RUN set -eux; \
    curl -f -L "${APACHE_DIST}/hive/KEYS" | gpg --batch --import -; \
    curl -f -LO "${APACHE_MIRROR}/hive/hive-${HIVE_VERSION}/apache-hive-${HIVE_VERSION}-bin.tar.gz"; \
    curl -f -L "${APACHE_DIST}/hive/hive-${HIVE_VERSION}/apache-hive-${HIVE_VERSION}-bin.tar.gz.asc" \
           | gpg --batch --verify - "apache-hive-${HIVE_VERSION}-bin.tar.gz";
RUN tar -xf  "apache-hive-${HIVE_VERSION}-bin.tar.gz" --no-same-owner; rm "apache-hive-${HIVE_VERSION}-bin.tar.gz" \
    mv       "apache-hive-${HIVE_VERSION}-bin" "hive";



FROM dungdm93/hadoop:${HADOOP_VERSION}

# Tools
RUN set -eux; \
    apt-get update; \
    apt-get install --no-install-recommends -y netcat; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/*

ENV HIVE_HOME="/opt/hive" \
    PATH="/opt/hive/bin:${PATH}"

COPY --from=downloader "/build/hive" "${HIVE_HOME}"
