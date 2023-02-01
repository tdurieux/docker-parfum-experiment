FROM golang:1.8.3-alpine

# Building ffmpeg 3.3 alpine binaries
# ---------------------------------
# ffmpeg - http://ffmpeg.org/download.html
#
# https://hub.docker.com/r/jrottenberg/ffmpeg/
#
#
# FROM        alpine:3.4
# MAINTAINER  Julien Rottenberg <julien@rottenberg.info>

WORKDIR     /tmp/workdir

ENV         FFMPEG_VERSION=3.3.1     \
            FDKAAC_VERSION=0.1.5      \
            LAME_VERSION=3.99.5       \
            OGG_VERSION=1.3.2         \
            OPENCOREAMR_VERSION=0.1.4 \
            OPUS_VERSION=1.1.4        \
            THEORA_VERSION=1.1.1      \
            VORBIS_VERSION=1.3.5      \
            VPX_VERSION=1.6.1         \
            X264_VERSION=20170226-2245-stable \
            X265_VERSION=2.3          \
            XVID_VERSION=1.3.4        \
            PKG_CONFIG_PATH=/usr/local/lib/pkgconfig \
            SRC=/usr/local

ARG         OGG_SHA256SUM="e19ee34711d7af328cb26287f4137e70630e7261b17cbe3cd41011d73a654692  libogg-1.3.2.tar.gz"
ARG         OPUS_SHA256SUM="9122b6b380081dd2665189f97bfd777f04f92dc3ab6698eea1dbb27ad59d8692  opus-1.1.4.tar.gz"
ARG         VORBIS_SHA256SUM="6efbcecdd3e5dfbf090341b485da9d176eb250d893e3eb378c428a2db38301ce  libvorbis-1.3.5.tar.gz"
ARG         THEORA_SHA256SUM="40952956c47811928d1e7922cda3bc1f427eb75680c3c37249c91e949054916b  libtheora-1.1.1.tar.gz"
ARG         XVID_SHA256SUM="4e9fd62728885855bc5007fe1be58df42e5e274497591fec37249e1052ae316f  xvidcore-1.3.4.tar.gz"
ARG         FFMPEG_KEY="D67658D8"

RUN     buildDeps="autoconf \
                   automake \
                   bash \
                   binutils \
                   bzip2 \
                   cmake \
                   curl \
                   coreutils \
                   g++ \
                   gcc \
                   gnupg \
                   libtool \
                   make \
                   python \
                   openssl-dev \
                   tar \
                   yasm \
                   zlib-dev" && \
        export MAKEFLAGS="-j$(($(grep -c ^processor /proc/cpuinfo) + 1))" && \
        apk  add --update ${buildDeps} libgcc libstdc++ ca-certificates

RUN \
## opencore-amr https://sourceforge.net/projects/opencore-amr/
        DIR=$(mktemp -d) && cd ${DIR} && \
        curl -sL https://downloads.sf.net/project/opencore-amr/opencore-amr/opencore-amr-${OPENCOREAMR_VERSION}.tar.gz | \
        tar -zx --strip-components=1 && \
        ./configure --prefix="${SRC}" --bindir="${SRC}/bin" --enable-shared --datadir=${DIR} && \
        make && \
        make install && \
        rm -rf ${DIR}
RUN \
## x264 http://www.videolan.org/developers/x264.html
       DIR=$(mktemp -d) && cd ${DIR} && \
       curl -sL https://ftp.videolan.org/pub/videolan/x264/snapshots/x264-snapshot-${X264_VERSION}.tar.bz2 | \
       tar -jx --strip-components=1 && \
       ./configure --prefix="${SRC}" --bindir="${SRC}/bin" --enable-pic --enable-shared --disable-cli && \
       make && \
       make install && \
       rm -rf ${DIR}
RUN \
## x265 http://x265.org/
        DIR=$(mktemp -d) && cd ${DIR} && \
        curl -sL https://download.videolan.org/pub/videolan/x265/x265_${X265_VERSION}.tar.gz  | \
        tar -zx && \
        cd x265_${X265_VERSION}/build/linux && \
        ./multilib.sh && \
        make -C 8bit install && \
        rm -rf ${DIR}
RUN \
## libogg https://www.xiph.org/ogg/
        DIR=$(mktemp -d) && cd ${DIR} && \
        curl -sLO http://downloads.xiph.org/releases/ogg/libogg-${OGG_VERSION}.tar.gz && \
        echo ${OGG_SHA256SUM} | sha256sum --check && \
        tar -zx --strip-components=1 -f libogg-${OGG_VERSION}.tar.gz && \
        ./configure --prefix="${SRC}" --bindir="${SRC}/bin" --disable-static --datarootdir=${DIR} && \
        make && \
        make install && \
        rm -rf ${DIR}
RUN \
## libopus https://www.opus-codec.org/
        DIR=$(mktemp -d) && cd ${DIR} && \
        curl -sLO http://downloads.xiph.org/releases/opus/opus-${OPUS_VERSION}.tar.gz && \
        echo ${OPUS_SHA256SUM} | sha256sum --check && \
        tar -zx --strip-components=1 -f opus-${OPUS_VERSION}.tar.gz && \
        autoreconf -fiv && \
        ./configure --prefix="${SRC}" --disable-static --datadir="${DIR}" && \
        make && \
        make install && \
        rm -rf ${DIR}
RUN \
## libvorbis https://xiph.org/vorbis/
        DIR=$(mktemp -d) && cd ${DIR} && \
        curl -sLO http://downloads.xiph.org/releases/vorbis/libvorbis-${VORBIS_VERSION}.tar.gz && \
        echo ${VORBIS_SHA256SUM} | sha256sum --check && \
        tar -zx --strip-components=1 -f libvorbis-${VORBIS_VERSION}.tar.gz && \
        ./configure --prefix="${SRC}" --with-ogg="${SRC}" --bindir="${SRC}/bin" \
        --disable-static --datadir="${DIR}" && \
        make && \
        make install && \
        rm -rf ${DIR}
RUN \
## libtheora http://www.theora.org/
        DIR=$(mktemp -d) && cd ${DIR} && \
        curl -sLO http://downloads.xiph.org/releases/theora/libtheora-${THEORA_VERSION}.tar.gz && \
        echo ${THEORA_SHA256SUM} | sha256sum --check && \
        tar -zx --strip-components=1 -f libtheora-${THEORA_VERSION}.tar.gz && \
        ./configure --prefix="${SRC}" --with-ogg="${SRC}" --bindir="${SRC}/bin" \
        --disable-static --datadir="${DIR}" && \
        make && \
        make install && \
        rm -rf ${DIR}
RUN \
## libvpx https://www.webmproject.org/code/
        DIR=$(mktemp -d) && cd ${DIR} && \
        curl -sL https://codeload.github.com/webmproject/libvpx/tar.gz/v${VPX_VERSION} | \
        tar -zx --strip-components=1 && \
        ./configure --prefix="${SRC}" --enable-vp8 --enable-vp9 --enable-pic --disable-debug --disable-examples --disable-docs --disable-install-bins --enable-shared && \
        make && \
        make install && \
        rm -rf ${DIR}
RUN \
## libmp3lame http://lame.sourceforge.net/
        DIR=$(mktemp -d) && cd ${DIR} && \
        curl -sL https://downloads.sf.net/project/lame/lame/${LAME_VERSION%.*}/lame-${LAME_VERSION}.tar.gz | \
        tar -zx --strip-components=1 && \
        ./configure --prefix="${SRC}" --bindir="${SRC}/bin" --disable-static --enable-nasm --datarootdir="${DIR}" && \
        make && \
        make install && \
        rm -rf ${DIR}
RUN \
## xvid https://www.xvid.com/
        DIR=$(mktemp -d) && cd ${DIR} && \
        curl -sLO http://downloads.xvid.org/downloads/xvidcore-${XVID_VERSION}.tar.gz && \
        echo ${XVID_SHA256SUM} | sha256sum --check && \
        tar -zx -f xvidcore-${XVID_VERSION}.tar.gz && \
        cd xvidcore/build/generic && \
        ./configure --prefix="${SRC}" --bindir="${SRC}/bin" --datadir="${DIR}" --disable-static --enable-shared && \
        make && \
        make install && \
        rm -rf ${DIR}
RUN \
## fdk-aac https://github.com/mstorsjo/fdk-aac
        DIR=$(mktemp -d) && cd ${DIR} && \
        curl -sL https://github.com/mstorsjo/fdk-aac/archive/v${FDKAAC_VERSION}.tar.gz | \
        tar -zx --strip-components=1 && \
        autoreconf -fiv && \
        ./configure --prefix="${SRC}" --disable-static --datadir="${DIR}" && \
        make && \
        make install && \
        make distclean && \
        rm -rf ${DIR}
RUN \
## ffmpeg https://ffmpeg.org/
        DIR=$(mktemp -d) && cd ${DIR} && \
        gpg --keyserver hkp://pool.sks-keyservers.net:80 --recv-keys ${FFMPEG_KEY} && \
        curl -sLO http://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.gz && \
        curl -sLO http://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.gz.asc && \
        gpg --batch  --verify ffmpeg-${FFMPEG_VERSION}.tar.gz.asc ffmpeg-${FFMPEG_VERSION}.tar.gz && \
        tar -zx --strip-components=1 -f ffmpeg-${FFMPEG_VERSION}.tar.gz && \
        ./configure \
        --bindir="${SRC}/bin" \
        --disable-debug \
        --disable-doc \
        --disable-ffplay \
        --disable-static \
        --enable-avresample \
        --enable-gpl \
        --enable-libopencore-amrnb \
        --enable-libopencore-amrwb \
        --enable-libfdk_aac \
        --enable-libmp3lame \
        --enable-libopus \
        --enable-libtheora \
        --enable-libvorbis \
        --enable-libvpx \
        --enable-libx264 \
        --enable-libx265 \
        --enable-libxvid \
        --enable-nonfree \
        --enable-openssl \
        --enable-postproc \
        --enable-shared \
        --enable-small \
        --enable-version3 \
        --extra-cflags="-I${SRC}/include" \
        --extra-ldflags="-L${SRC}/lib" \
        --extra-libs=-ldl \
        --prefix="${SRC}" && \
        make && \
        make install && \
        make distclean && \
        hash -r && \
        cd tools && \
        make qt-faststart && \
        cp qt-faststart ${SRC}/bin && \
        rm -rf ${DIR}

RUN \
# cleanup
        cd && \
        apk del ${buildDeps} && \
	      rm -rf /var/cache/apk/* && \
        ffmpeg -buildconf

# Let's make sure the app built correctly
# Convenient to verify on https://hub.docker.com/r/jrottenberg/ffmpeg/builds/ console output
# ---------------------------------

ENV GOBIN=/go/bin

RUN apk add --no-cache git jpeg-dev zlib-dev libpng-dev

RUN git clone https://github.com/gpac/gpac.git
RUN gpac/configure --static-mp4box
RUN make -j4
RUN make install
RUN cp /tmp/workdir/bin/gcc/MP4Box /bin/MP4Box

RUN go get -u github.com/satori/go.uuid
RUN go get -u github.com/gin-gonic/gin
RUN go get -u github.com/nareix/joy4
RUN go get -u github.com/nareix/bits
RUN go get -u github.com/jinzhu/gorm
RUN go get -u github.com/jinzhu/gorm/dialects/postgres
RUN go get -u go.uber.org/zap

RUN mkdir -p /home/dev/lib

ENV CGO_LDFLAGS="-L${SRC}/lib -lavcodec -lavformat -lavutil -lswscale -lswresample -lavdevice -lavfilter"
ENV CGO_CFLAGS="-I${SRC}/include"
ENV LD_LIBRARY_PATH=/home/dev/lib

ADD common /go/src/github.com/n1207n/video-transcode-queue/api/common
ADD transcode /go/src/github.com/n1207n/video-transcode-queue/api/transcode

WORKDIR /go/src/github.com/n1207n/video-transcode-queue/api/transcode

RUN go build
RUN go install

ENTRYPOINT /go/bin/transcode

EXPOSE 8800
