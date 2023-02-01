FROM registry.rhc4tp.openshift.com/bitnami/rhel-extras-7:latest
LABEL maintainer "Bitnami <containers@bitnami.com>"

ENV BITNAMI_PKG_CHMOD="-R g+rwX" \
    HOME="/"

# Install required system packages and dependencies
RUN install_packages bzip2-libs ca-certificates curl gcc gcc-c++ git glibc keyutils-libs krb5-libs libcom_err libgcc libselinux libstdc++ libtool make ncurses-libs nss-softokn-freebl openssl-libs patch pcre pkgconfig readline sqlite unzip wget zlib
RUN bitnami-pkg install node-11.14.0-0 --checksum d67398c7063c751e4cf2bd8d74f6b43020a0ab392e8b2743a01851f4ad357260

COPY rootfs /
ENV BITNAMI_APP_NAME="node" \
    BITNAMI_IMAGE_VERSION="11.14.0-rhel-7-r5" \
    NAMI_PREFIX="/.nami" \
    PATH="/opt/bitnami/node/bin:/opt/bitnami/python/bin:$PATH"

EXPOSE 3000

WORKDIR /app
USER 1001
ENTRYPOINT [ "/app-entrypoint.sh" ]
CMD [ "node" ]
