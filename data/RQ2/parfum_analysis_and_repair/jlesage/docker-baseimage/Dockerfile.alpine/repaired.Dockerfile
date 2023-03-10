#
# baseimage Dockerfile
#
# https://github.com/jlesage/docker-baseimage
#

ARG BASEIMAGE=unknown

# Pull base image.
FROM ${BASEIMAGE}

# Define s6 overlay related variables.
ARG S6_OVERLAY_ARCH=x86_64
ARG S6_OVERLAY_VERSION=1.21.4.0
ARG S6_OVERLAY_URL=https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-${S6_OVERLAY_ARCH}.tar.gz

# Define GLIBC related variables.
ARG GLIBC_INSTALL=0
ARG GLIBC_ARCH=x86_64
ARG GLIBC_VERSION=2.31-r0
ARG GLIBC_URL=https://github.com/jlesage/glibc-bin-multiarch/releases/download/${GLIBC_VERSION}/glibc-bin-${GLIBC_VERSION}-${GLIBC_ARCH}.tar.gz
ARG GLIBC_LOCALE_INPUT=en_US
ARG GLIBC_LOCALE_CHARMAP=UTF-8
ARG GLIBC_LOCALE=${GLIBC_LOCALE_INPUT}.${GLIBC_LOCALE_CHARMAP}

# Define working directory.
WORKDIR /tmp

# Copy helpers.
COPY helpers/* /usr/local/bin/

# Install glibc if needed.
RUN \
    test "${GLIBC_INSTALL}" -eq 0 || ( add-pkg --virtual build-dependencies curl binutils alpine-sdk && \
    # Download and install glibc.
    curl -f -# -L ${GLIBC_URL} | tar xz -C / && \
    # Strip symbols.
    find /usr/glibc-compat/bin -type f -exec strip {} ';' && \
    find /usr/glibc-compat/sbin -type f -exec strip {} ';' && \
    find /usr/glibc-compat/lib -type f -exec strip {} ';' && \
    # Create /etc/nsswitch.conf.
    echo -n "hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4" > /etc/nsswitch.conf && \
    # Create /usr/glibc-compat/etc/ld.so.conf
    echo "# libc default configuration" >> /usr/glibc-compat/etc/ld.so.conf && \
    echo "/usr/local/lib" >> /usr/glibc-compat/etc/ld.so.conf && \
    echo "/usr/glibc-compat/lib" >> /usr/glibc-compat/etc/ld.so.conf && \
    echo "/usr/lib" >> /usr/glibc-compat/etc/ld.so.conf && \
    echo "/lib" >> /usr/glibc-compat/etc/ld.so.conf && \
    # Create required symbolic links.
    mkdir -p /lib /lib64 /usr/glibc-compat/lib/locale && \
    ln -s /usr/glibc-compat/lib/ld-linux-x86-64.so.2 /lib/ld-linux-x86-64.so.2 && \
    ln -s /usr/glibc-compat/lib/ld-linux-x86-64.so.2 /lib64/ld-linux-x86-64.so.2 && \
    ln -s /usr/glibc-compat/etc/ld.so.cache /etc/ld.so.cache && \
    # Run ldconfig.
    /usr/glibc-compat/sbin/ldconfig && \
    # Generate locale.
    /usr/glibc-compat/bin/localedef --inputfile ${GLIBC_LOCALE_INPUT} \
                                    --charmap ${GLIBC_LOCALE_CHARMAP} \
                                    ${GLIBC_LOCALE} && \
    # Timezone support.
    ln -s /usr/share/zoneinfo /usr/glibc-compat/share/zoneinfo && \
    # Add apk trigger.  This is needed so that ldconfig is called automatically
    # after apk installs libraries.
    echo 'pkgname=glibc-ldconfig-trigger' >> APKBUILD && \
    echo 'pkgver=1.0' >> APKBUILD && \
    echo 'pkgrel=0' >> APKBUILD && \
    echo 'pkgdesc="Dummy package that installs trigger for glibc ldconfig"' >> APKBUILD && \
    echo 'url="https://github.com/jlesage/docker-baseimage"' >> APKBUILD && \
    echo 'arch="noarch"' >> APKBUILD && \
    echo 'license="GPL"' >> APKBUILD && \
    echo 'makedepends=""' >> APKBUILD && \
    echo 'depends=""' >> APKBUILD && \
    echo 'install=""' >> APKBUILD && \
    echo 'subpackages=""' >> APKBUILD && \
    echo 'source=""' >> APKBUILD && \
    echo 'triggers="$pkgname.trigger=/lib:/usr/lib:/usr/glibc-compat/lib"' >> APKBUILD && \
    echo 'package() {' >> APKBUILD && \
    echo '        mkdir -p "$pkgdir"' >> APKBUILD && \
    echo '}' >> APKBUILD && \
    echo '#!/bin/sh' >> glibc-ldconfig-trigger.trigger && \
    echo '/usr/glibc-compat/sbin/ldconfig' >> glibc-ldconfig-trigger.trigger && \
    chmod +x glibc-ldconfig-trigger.trigger && \
    adduser -D -G abuild -s /bin/sh abuild && \
    su abuild -c "abuild-keygen -a -n" && \
    su abuild -c "abuild" && \
    cp /home/abuild/packages/*/glibc-ldconfig-trigger-1.0-r0.apk . && \
    apk --no-cache --allow-untrusted add glibc-ldconfig-trigger-1.0-r0.apk && \
    deluser --remove-home abuild && \
    # Remove unneeded stuff.
    rm /usr/glibc-compat/etc/rpc && \
    rm /usr/glibc-compat/lib/*.a && \
    rm -r /usr/glibc-compat/lib/audit && \
    rm -r /usr/glibc-compat/lib/gconv && \
    rm -r /usr/glibc-compat/lib/getconf && \
    rm -r /usr/glibc-compat/include && \
    rm -r /usr/glibc-compat/share/locale && \
    rm -r /usr/glibc-compat/share/i18n && \
    rm -r /usr/glibc-compat/var && \
    # Cleanup
    del-pkg build-dependencies && \
    rm -rf /tmp/* /tmp/.[!.]*)

# Install s6 overlay.
RUN \
    add-pkg --virtual build-dependencies curl tar patch && \
    echo "Downloading s6-overlay..." && \
    curl -f -# -L ${S6_OVERLAY_URL} | tar -xz -C / && \
    # Services dependencies support.
    echo "Patching s6-overlay..." && \
    curl -f -# -L https://github.com/jlesage/s6-overlay/commit/d151c41.patch | patch -d / -p3 && \
    chmod +x \
        /etc/s6/services/.s6-svscan/SIGHUP \
        /etc/s6/services/.s6-svscan/SIGINT \
        /etc/s6/services/.s6-svscan/SIGQUIT \
        /etc/s6/services/.s6-svscan/SIGTERM \
        /usr/bin/sv-getdeps \
        && \
    # Cleanup
    del-pkg build-dependencies && \
    rm -rf /tmp/* /tmp/.[!.]*

# Install system packages.
RUN \
    add-pkg \
        # For timezone support
        tzdata \
        # For 'groupmod' command
        shadow

# Save some defaults.
RUN \
    mkdir /defaults && \
    cp /etc/passwd /defaults/ && \
    cp /etc/group /defaults/ && \
    cp /etc/shadow /defaults/

# Add files.
COPY rootfs/ /

# Set environment variables.
ENV LANG=${GLIBC_LOCALE} \
    S6_BEHAVIOUR_IF_STAGE2_FAILS=3 \
    S6_SERVICE_DEPS=1 \
    USER_ID=1000 \
    GROUP_ID=1000 \
    APP_NAME=DockerApp \
    APP_USER=app \
    XDG_DATA_HOME=/config/xdg/data \
    XDG_CONFIG_HOME=/config/xdg/config \
    XDG_CACHE_HOME=/config/xdg/cache \
    XDG_RUNTIME_DIR=/tmp/run/user/app

# Define mountable directories.
VOLUME ["/config"]

# Define default command.
# Use S6 overlay init system.
CMD ["/init"]

# Metadata.
ARG IMAGE_VERSION=unknown
LABEL \
      org.label-schema.name="baseimage" \
      org.label-schema.description="A minimal docker baseimage to ease creation of long-lived application containers" \
      org.label-schema.version="${IMAGE_VERSION}" \
      org.label-schema.vcs-url="https://github.com/jlesage/docker-baseimage" \
      org.label-schema.schema-version="1.0"
