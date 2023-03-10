#
# Docker file for Laniakea CI
#
FROM debian:testing

# prepare
RUN mkdir -p /build/ci/

# install build dependencies
COPY install-native-deps.sh /build/ci/
RUN chmod +x /build/ci/install-native-deps.sh && /build/ci/install-native-deps.sh

# Podman within podman config
ADD https://raw.githubusercontent.com/containers/libpod/master/contrib/podmanimage/stable/containers.conf /etc/containers/containers.conf
RUN chmod 644 /etc/containers/containers.conf
ENV _CONTAINERS_USERNS_CONFIGURED=""

COPY storage.conf /etc/containers/
RUN chmod 644 /etc/containers/containers.conf

VOLUME /var/lib/containers
RUN mkdir -p /var/lib/shared/overlay-images /var/lib/shared/overlay-layers /var/lib/shared/vfs-images /var/lib/shared/vfs-layers; touch /var/lib/shared/overlay-images/images.lock; touch /var/lib/shared/overlay-layers/layers.lock; touch /var/lib/shared/vfs-images/images.lock; touch /var/lib/shared/vfs-layers/layers.lock

# finish