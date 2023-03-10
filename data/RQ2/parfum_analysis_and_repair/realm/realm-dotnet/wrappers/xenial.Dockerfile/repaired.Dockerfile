FROM ubuntu:xenial

ARG PACKAGECLOUD_URL
ARG REALM_CORE_VERSION
ARG REALM_SYNC_VERSION

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
            curl \
            cmake \
            build-essential \
            cpp \
            libssl-dev && rm -rf /var/lib/apt/lists/*;

RUN curl -f -s ${PACKAGECLOUD_URL}/script.deb.sh | bash
RUN apt-get install --no-install-recommends -y \
            librealm=${REALM_CORE_VERSION}-* \
            librealm-dev=${REALM_CORE_VERSION}-* \
            librealm-node-dev=${REALM_CORE_VERSION}-* \
            librealm-sync=${REALM_SYNC_VERSION}-* \
            librealm-sync-dev=${REALM_SYNC_VERSION}-* \
            librealm-sync-node-dev=${REALM_SYNC_VERSION}-* && rm -rf /var/lib/apt/lists/*;

VOLUME /source
CMD ["/source/build.sh"]
