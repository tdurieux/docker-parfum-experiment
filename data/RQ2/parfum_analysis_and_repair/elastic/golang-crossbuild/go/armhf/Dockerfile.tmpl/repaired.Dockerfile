ARG REPOSITORY
ARG VERSION
ARG TAG_EXTENSION=''
FROM ${REPOSITORY}/golang-crossbuild:${VERSION}-base${TAG_EXTENSION}

RUN dpkg --add-architecture armhf \
    && apt update -y --no-install-recommends \
    && apt upgrade -y --no-install-recommends \
    && apt full-upgrade -y --no-install-recommends \
    && apt install -qq -y --no-install-recommends \
        crossbuild-essential-armhf \
        linux-libc-dev-armhf-cross && rm -rf /var/lib/apt/lists/*;

RUN apt install --no-install-recommends -qq -y \
        libc-dev:armhf \
        libpopt-dev:armhf \
        linux-libc-dev:armhf && rm -rf /var/lib/apt/lists/*;

{{- if eq .DEBIAN_VERSION "9"}}
# librpm-dev
RUN apt install --no-install-recommends -y \
        librpm-dev:armhf \
        librpm3:armhf \
        librpmio3:armhf \
        librpmbuild3:armhf \
        librpmsign3:armhf \
        libxml2-dev:armhf \
        libsqlite3-dev:armhf \
        libnss3:armhf \
        libsqlite3-0:armhf \
        libxml2:armhf \
        libsqlite3-0:armhf && rm -rf /var/lib/apt/lists/*;

# libsystemd-dev
RUN apt install --no-install-recommends -y \
        libsystemd-dev:armhf libsystemd0:armhf liblz4-1:armhf && rm -rf /var/lib/apt/lists/*;
{{- end }}

{{- if or (eq .DEBIAN_VERSION "10") (eq .DEBIAN_VERSION "11")}}
# librpm-dev
RUN apt install --no-install-recommends -y \
        librpm-dev:armhf && rm -rf /var/lib/apt/lists/*;

# libsystemd-dev
RUN apt install --no-install-recommends -y \
        libsystemd-dev:armhf && rm -rf /var/lib/apt/lists/*;
{{- end }}

RUN rm -rf /var/lib/apt/lists/*

COPY rootfs /

# Basic test
RUN cd / \
  && arm-linux-gnueabihf-gcc helloWorld.c -o helloWorld \
  && file helloWorld \
  && readelf -h helloWorld \
  && file helloWorld | cut -d "," -f 5 | grep -c 'armhf.so'\
  && rm helloWorld.c helloWorld

RUN cd /libpcap/libpcap-1.8.1 \
	&& CC=arm-linux-gnueabihf-gcc ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-usb=no --enable-bluetooth=no --enable-dbus=no --host=arm-linux-gnueabihf --with-pcap=linux \
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
