ARG QEMU_ARCH
ARG DISTRO_VERSION
FROM multiarch/qemu-user-static:x86_64-${QEMU_ARCH} as qemu
FROM ubuntu:${DISTRO_VERSION} 

ARG QEMU_ARCH
COPY --from=qemu /usr/bin/qemu-${QEMU_ARCH}-static /usr/bin

ARG DISTRO_VERSION_NAME
ARG DISTRO_VERSION

RUN apt update && DEBIAN_FRONTEND=noninteractive apt install -y dos2unix devscripts dh-make wget gettext-base lintian curl dh-systemd debhelper

RUN apt update \ 
    && apt-get -y dist-upgrade \
    && apt install -y curl wget apt-transport-https 

ENV DEBEMAIL=support@ravendb.net DEBFULLNAME="Hibernating Rhinos LTD" 
ENV DEB_ARCHITECTURE="" DOTNET_RUNTIME_VERSION="" DOTNET_DEPS_VERSION=""
ENV RAVEN_PLATFORM="" RAVEN_ARCH=""
ENV TARBALL_CACHE_DIR="/cache"

ENV BUILD_DIR=/build
ENV OUTPUT_DIR=/dist/${DISTRO_VERSION}

COPY assets/ravendb/ /assets/ravendb/
COPY assets/ravendb/ /build/ravendb/
COPY assets/build.sh /build/

RUN find /build -type f -print0 | xargs -0 dos2unix -v \
    && chmod 555 /build/build.sh

WORKDIR /build/ravendb

CMD /build/build.sh
