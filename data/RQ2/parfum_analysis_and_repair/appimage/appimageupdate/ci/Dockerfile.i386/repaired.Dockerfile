ARG DIST
FROM i386/ubuntu:${DIST}

ENV ARCH=i386

# must repeat this after FROM, otherwise it won't be set
ARG DIST

RUN apt-get update && \
    apt-get install -y --no-install-recommends software-properties-common && \
    add-apt-repository -y ppa:beineri/opt-qt-5.15.2-"${DIST}" && \
    apt-get update && \
    apt-get install --no-install-recommends -y qt515base qt515wayland libgl1 libdrm-dev mesa-common-dev \
        build-essential libssl-dev autoconf automake libtool \
        wget vim-common desktop-file-utils pkgconf \
        libglib2.0-dev libcairo2-dev librsvg2-dev libfuse-dev git libcurl4-openssl-dev argagg-dev libgcrypt20-dev nlohmann-json-dev && \
    wget -qO- https://artifacts.assassinate-you.net/prebuilt-cmake/cmake-v3.22.1-ubuntu_xenial-$ARCH.tar.gz | tar xzv -C/usr --strip-components=1 && rm -rf /var/lib/apt/lists/*;

COPY libgcrypt.pc /usr/lib/i386-linux-gnu/pkgconfig/libgcrypt.pc
RUN sed -i 's|x86_64|i386|g' /usr/lib/i386-linux-gnu/pkgconfig/libgcrypt.pc

COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]

ENV APPIMAGE_EXTRACT_AND_RUN=1

ENV DOCKER=1
