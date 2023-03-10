ARG BUILD_PLATFORM
FROM ompzowe/server-bundle:${BUILD_PLATFORM}

ENV NODE_VERSION 12.22.0

RUN mkdir -p /root/sources/utils && \
    cd /root/sources && \
    apt-get update && apt-get install -y wget --no-install-recommends && \
    wget https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}.tar.xz && rm -rf /var/lib/apt/lists/*;

COPY utils/get-deb-sources.sh /root/sources/utils

RUN cd /root/sources/utils && \
    chmod +x get-deb-sources.sh && \
    ./get-deb-sources.sh




