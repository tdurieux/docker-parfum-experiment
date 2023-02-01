# This should be kept in sync with dev/builder.local.Dockerfile

FROM debian:stable-slim as builder
ARG VERSION
ARG TARGETARCH
RUN apt-get -q update && \
    apt-get -q --no-install-recommends install -y curl unzip \
    zlib1g=1:1.2.11.dfsg-2+deb11u1 && rm -rf /var/lib/apt/lists/*; # CVE-2018-25032
WORKDIR /protocurl
COPY dist/protocurl_${VERSION}_linux_${TARGETARCH}.zip ./
RUN unzip *.zip && rm -f *.md *.zip && ls -lh . && apt-get -q purge -y unzip
COPY LICENSE.md README.md ./
