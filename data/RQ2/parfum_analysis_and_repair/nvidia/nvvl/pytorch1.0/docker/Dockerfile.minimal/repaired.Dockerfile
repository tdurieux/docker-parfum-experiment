FROM nvcr.io/nvidia/pytorch:18.11-py3

ARG FFMPEG_VERSION=4.1

# nvcuvid deps
RUN apt-get update --fix-missing && \
    apt-get install --no-install-recommends -y libx11-6 libxext6 && rm -rf /var/lib/apt/lists/*;
ENV NVIDIA_DRIVER_CAPABILITIES=video,compute,utility

# minimal ffmpeg from source
RUN apt-get install --no-install-recommends -y yasm && \
    cd /tmp && wget -q https://ffmpeg.org/releases/ffmpeg-$FFMPEG_VERSION.tar.bz2 && \
    tar xf ffmpeg-$FFMPEG_VERSION.tar.bz2 && \
    rm ffmpeg-$FFMPEG_VERSION.tar.bz2 && \
    cd ffmpeg-$FFMPEG_VERSION && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
      --prefix=/usr/local \
      --disable-static \
      --disable-all \
      --disable-autodetect \
      --disable-iconv \
      --enable-shared \
      --enable-avformat \
      --enable-avcodec \
      --enable-avfilter \
      --enable-protocol=file \
      --enable-demuxer=mov,matroska \
      --enable-bsf=h264_mp4toannexb,hevc_mp4toannexb && \
    make -j8 && make install && \
    cd /tmp && rm -rf ffmpeg-$FFMPEG_VERSION && \
    apt-get remove -y yasm && rm -rf /var/lib/apt/lists/*;
