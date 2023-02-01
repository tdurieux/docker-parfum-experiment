ARG IMAGE=resin/rpi-raspbian:stretch

FROM $IMAGE as builder

MAINTAINER datarhei <info@datarhei.org>

ARG LAME_VERSION=3.100
ARG X264_VERSION=20190409-2245-stable
ARG X265_VERSION=3.0
ARG FFMPEG_VERSION=4.1.3
ARG NGINX_VERSION=1.14.2
ARG NGINXRTMP_VERSION=1.2.1
ARG NODE_VERSION=10.15.3

ENV SRC="/usr/local/" \
    LD_LIBRARY_PATH="/usr/local/lib" \
    PKG_CONFIG_PATH="/usr/local/lib/pkgconfig"

RUN apt-get update && \
    apt-get install -y \
        pkg-config \
        curl \
        libpcre3-dev \
        libtool \
        libssl-dev \
        zlib1g-dev \
        libasound2-dev \
        build-essential

# x264
RUN mkdir -p /dist && cd /dist && \
    curl -OL "http://ftp.videolan.org/pub/videolan/x264/snapshots/x264-snapshot-${X264_VERSION}.tar.bz2" && \
    tar -xvj -f x264-snapshot-${X264_VERSION}.tar.bz2 && \
    cd x264-snapshot-${X264_VERSION} && \
    ./configure --prefix="${SRC}" --bindir="${SRC}/bin" --enable-shared && \
    make -j$(nproc) && \
    make install

# libmp3lame
RUN mkdir -p /dist && cd /dist && \
    curl -OL "https://kent.dl.sourceforge.net/project/lame/lame/${LAME_VERSION}/lame-${LAME_VERSION}.tar.gz" && \
    tar -xvz -f lame-${LAME_VERSION}.tar.gz && \
    cd lame-${LAME_VERSION} && \
    ./configure --prefix="${SRC}" --bindir="${SRC}/bin" --disable-static && \
    make -j$(nproc) && \
    make install

# ffmpeg && patch
COPY ./contrib/ffmpeg /dist/restreamer/contrib/ffmpeg

RUN mkdir -p /dist && cd /dist && \
    curl -OL "https://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.gz" && \
    tar -xvz -f ffmpeg-${FFMPEG_VERSION}.tar.gz && \
    cd ffmpeg-${FFMPEG_VERSION} && \
    patch -p1 < /dist/restreamer/contrib/ffmpeg/bitrate.patch && \
    ./configure \
        --bindir="${SRC}/bin" \
        --extra-cflags="-I${SRC}/include" \
        --extra-ldflags="-L${SRC}/lib" \
        --prefix="${SRC}" \
        --enable-nonfree \
        --enable-gpl \
        --enable-version3 \
        --enable-libmp3lame \
        --enable-libx264 \
        --enable-openssl \
        --enable-postproc \
        --enable-small \
        --enable-static \
        --disable-debug \
        --disable-doc \
        --disable-shared && \
    make -j$(nproc) && \
    make install

# nginx-rtmp
RUN mkdir -p /dist && cd /dist && \
    curl -OL "https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz" && \
    tar -xvz -f "nginx-${NGINX_VERSION}.tar.gz" && \
    curl -OL "https://github.com/arut/nginx-rtmp-module/archive/v${NGINXRTMP_VERSION}.tar.gz" && \
    tar -xvz -f "v${NGINXRTMP_VERSION}.tar.gz" && \
    cd nginx-${NGINX_VERSION} && \
    ./configure --prefix=/usr/local/nginx --with-http_ssl_module --with-http_v2_module --add-module=/dist/nginx-rtmp-module-${NGINXRTMP_VERSION} && \
    make -j$(nproc) && \
    make install

# node.js
RUN mkdir -p /dist && cd /dist && \
    curl -OL "https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-armv6l.tar.xz" && \
    tar -xvJ -f "node-v${NODE_VERSION}-linux-armv6l.tar.xz" && \
    cd node-v${NODE_VERSION}-linux-armv6l && \
    cp -R bin /usr/local && \
    cp -R lib /usr/local

RUN rm -r /dist && \
    apt-get remove -y \
        pkg-config \
        curl \
        libpcre3-dev \
        libtool \
        libssl-dev \
        zlib1g-dev \
        build-essential && \
    apt-get autoremove -y

FROM $IMAGE

COPY --from=builder /usr/local/bin /usr/local/bin
COPY --from=builder /usr/local/nginx /usr/local/nginx
COPY --from=builder /usr/local/lib /usr/local/lib

RUN apt-get update && \
    apt-get install -y \
        ca-certificates \
        git \
        procps \
        libpcre3 \
        openssl \
        libssl-dev \
        zlib1g \
        v4l-utils \
        libv4l-0 \
        alsa-utils

COPY . /restreamer
WORKDIR /restreamer

RUN cd /restreamer && \
    npm install -g grunt-cli nodemon eslint && \
    npm install && \
    grunt build && \
    npm prune --production && \
    npm cache verify && \
    npm uninstall -g grunt-cli nodemon eslint && \
    npm prune --production && \
    apt-get remove -y \
        git \
        curl && \
    apt-get autoremove -y

EXPOSE 8080
EXPOSE 8181

VOLUME ["/restreamer/db"]

CMD ["./run.sh"]
