# GuestOS - Base Image
#
# Build steps:
# - `docker build -t dfinity/guestos-base:<tag> -f Dockerfile.base .`
# - `docker push/pull dfinity/guestos-base:<tag>`
# - `docker build -t dfinity/guestos-base-dev:<tag> --build-arg PACKAGE_FILES="packages.common packages.dev" -f Dockerfile.base .`
# - `docker push/pull dfinity/guestos-base-dev:<tag>`
#
# NOTE! If you edit this file, you will need to perform the following
# operations to get your changes deployed.
#
# 1. Get your MR approved and merged into master
# 2. On the next hourly master pipeline, click the "deploy-guest-os-baseimg" job
# 3. Note the sha256 and update the sha256 reference in the neighboring Dockerfiles.
#

#
# First build stage:
# - Download 3rd party tools
#
FROM ubuntu:20.04 as download

ENV TZ=UTC
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get -y update && apt-get -y upgrade && apt-get -y --no-install-recommends install \
    ca-certificates \
    curl \
    perl && rm -rf /var/lib/apt/lists/*;

# Download and verify journalbeat
RUN cd /tmp/ && \
    curl -f -L -O https://artifacts.elastic.co/downloads/beats/journalbeat/journalbeat-oss-7.14.0-linux-x86_64.tar.gz && \
    echo "3c97e8706bd0d2e30678beee7537b6fe6807cf858a0dd2e7cfce5beccb621eb0fefe6871027bc7b55e2ea98d7fe2ca03d4d92a7b264abbb0d6d54ecfa6f6a305  journalbeat-oss-7.14.0-linux-x86_64.tar.gz" > journalbeat.sha512 && \
    shasum -c journalbeat.sha512

# Download and verify node_exporter
RUN cd /tmp/ && \
    curl -f -L -O https://github.com/prometheus/node_exporter/releases/download/v1.3.1/node_exporter-1.3.1.linux-amd64.tar.gz && \
    echo "68f3802c2dd3980667e4ba65ea2e1fb03f4a4ba026cca375f15a0390ff850949  node_exporter-1.3.1.linux-amd64.tar.gz" > node_exporter.sha256 && \
    shasum -c node_exporter.sha256

#
# Second build stage:
# - Download and cache minimal Ubuntu Server 20.04 LTS Docker image
# - Install and cache upstream packages from built-in Ubuntu repositories
# - Copy downloaded archives from first build stage into the target image
#
FROM ubuntu:20.04

ENV SOURCE_DATE_EPOCH=0
ENV TZ=UTC

# For the prod image, just use packages.common to define the packages installed
# on target.
# For the dev image, use both "packages.common" and "packages.dev" -- this can
# be set via docker build args (see above).
ARG PACKAGE_FILES=packages.common
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
COPY packages.* /tmp/
RUN apt-get -y update && \
    apt-get -y upgrade && \
    apt-get -y --no-install-recommends install $(for P in ${PACKAGE_FILES}; do cat /tmp/$P | sed -e "s/#.*//" ; done) && \
    rm /tmp/packages.* && rm -rf /var/lib/apt/lists/*;

# Install journalbeat
COPY --from=download /tmp/journalbeat-oss-7.14.0-linux-x86_64.tar.gz /tmp/journalbeat-oss-7.14.0-linux-x86_64.tar.gz
RUN cd /tmp/ && \
    mkdir -p /etc/journalbeat \
             /var/lib/journalbeat \
             /var/log/journalbeat && \
    tar --strip-components=1 -C /etc/journalbeat/ -zvxf journalbeat-oss-7.14.0-linux-x86_64.tar.gz journalbeat-7.14.0-linux-x86_64/fields.yml && \
    tar --strip-components=1 -C /etc/journalbeat/ -zvxf journalbeat-oss-7.14.0-linux-x86_64.tar.gz journalbeat-7.14.0-linux-x86_64/journalbeat.reference.yml && \
    tar --strip-components=1 -C /usr/local/bin/ -zvxf journalbeat-oss-7.14.0-linux-x86_64.tar.gz journalbeat-7.14.0-linux-x86_64/journalbeat && \
    rm /tmp/journalbeat-oss-7.14.0-linux-x86_64.tar.gz

# Install node_exporter
COPY --from=download /tmp/node_exporter-1.3.1.linux-amd64.tar.gz /tmp/node_exporter-1.3.1.linux-amd64.tar.gz
RUN cd /tmp/ && \
    mkdir -p /etc/node_exporter && \
    tar --strip-components=1 -C /usr/local/bin/ -zvxf node_exporter-1.3.1.linux-amd64.tar.gz node_exporter-1.3.1.linux-amd64/node_exporter && \
    rm /tmp/node_exporter-1.3.1.linux-amd64.tar.gz
