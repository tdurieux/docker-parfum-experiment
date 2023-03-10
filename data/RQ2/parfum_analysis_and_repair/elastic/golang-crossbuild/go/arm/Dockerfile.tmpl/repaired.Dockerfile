ARG REPOSITORY
ARG VERSION
ARG TAG_EXTENSION=''
FROM --platform=linux/amd64 ${REPOSITORY}/golang-crossbuild:${VERSION}-base${TAG_EXTENSION} as stage-amd64

RUN dpkg --add-architecture arm64 \
    && apt update -y --no-install-recommends \
    && apt upgrade -y --no-install-recommends \
    && apt full-upgrade -y --no-install-recommends \
    && apt install -qq -y --no-install-recommends \
        crossbuild-essential-arm64 \
        linux-libc-dev-arm64-cross && rm -rf /var/lib/apt/lists/*;

RUN apt install --no-install-recommends -qq -y \
        libc-dev:arm64 \
        libpopt-dev:arm64 \
        linux-libc-dev:arm64 && rm -rf /var/lib/apt/lists/*;

{{- if eq .DEBIAN_VERSION "9"}}
# librpm-dev
RUN apt install --no-install-recommends -y \
        librpm-dev:arm64 \
        librpm3:arm64 \
        librpmio3:arm64 \
        librpmbuild3:arm64 \
        librpmsign3:arm64 \
        libxml2-dev:arm64 \
        libsqlite3-dev:arm64 \
        libnss3:arm64 \
        libsqlite3-0:arm64 \
        libxml2:arm64 \
        libsqlite3-0:arm64 && rm -rf /var/lib/apt/lists/*;

# libsystemd-dev
RUN apt install --no-install-recommends -y \
        libsystemd-dev:arm64 libsystemd0:arm64 liblz4-1:arm64 && rm -rf /var/lib/apt/lists/*;
{{- end }}

{{- if or (eq .DEBIAN_VERSION "10") (eq .DEBIAN_VERSION "11")}}
# librpm-dev
RUN apt install --no-install-recommends -y \
        librpm-dev:arm64 && rm -rf /var/lib/apt/lists/*;

# libsystemd-dev
RUN apt install --no-install-recommends -y \
        libsystemd-dev:arm64 && rm -rf /var/lib/apt/lists/*;
{{- end }}

ARG REPOSITORY
ARG VERSION
ARG TAG_EXTENSION=''
FROM --platform=linux/arm64 ${REPOSITORY}/golang-crossbuild:${VERSION}-base${TAG_EXTENSION} as stage-arm64

RUN dpkg --add-architecture arm64 \
    && apt update -y --no-install-recommends \
    && apt upgrade -y --no-install-recommends \
    && apt full-upgrade -y --no-install-recommends \
    && apt install -qq -y --no-install-recommends \
        build-essential \
        libc-dev \
        libpopt-dev \
        linux-libc-dev && rm -rf /var/lib/apt/lists/*;

{{- if eq .DEBIAN_VERSION "9"}}
# librpm-dev
RUN apt install --no-install-recommends -y \
        librpm-dev \
        librpm3 \
        librpmio3 \
        librpmbuild3 \
        librpmsign3 \
        libxml2-dev \
        libsqlite3-dev \
        libnss3 \
        libsqlite3-0 \
        libxml2 \
        libsqlite3-0 && rm -rf /var/lib/apt/lists/*;

# libsystemd-dev
RUN apt install --no-install-recommends -y \
        libsystemd-dev libsystemd0 liblz4-1 && rm -rf /var/lib/apt/lists/*;
{{- end }}

{{- if or (eq .DEBIAN_VERSION "10") (eq .DEBIAN_VERSION "11")}}
# librpm-dev
RUN apt install --no-install-recommends -y \
        librpm-dev && rm -rf /var/lib/apt/lists/*;

# libsystemd-dev
RUN apt install --no-install-recommends -y \
        libsystemd-dev && rm -rf /var/lib/apt/lists/*;
{{- end }}

# Declare TARGETARCH to make it available
ARG TARGETARCH=amd64
# Select final stage based on TARGETARCH ARG
FROM stage-${TARGETARCH} as final

RUN rm -rf /var/lib/apt/lists/*

COPY rootfs /

# Basic test
RUN cd / \
  && aarch64-linux-gnu-gcc helloWorld.c -o helloWorld \
  && file helloWorld \
  && readelf -h helloWorld \
  && file helloWorld | cut -d "," -f 2 | grep -c 'ARM aarch64'\
  && rm helloWorld.c helloWorld

RUN cd /libpcap/libpcap-1.8.1 \
	&& CC=aarch64-linux-gnu-gcc ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-usb=no --enable-bluetooth=no --enable-dbus=no --host=aarch64-unknown-linux-gnu --with-pcap=linux \
	&& make

# Build-time metadata as defined at http://label-schema.org.
ARG BUILD_DATE
ARG IMAGE
ARG VCS_REF
ARG VCS_URL
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name=$IMAGE \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url=$VCS_URL \
      org.label-schema.schema-version="1.0"
