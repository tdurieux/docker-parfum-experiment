ARG CUDA_VERSION=9.1
FROM nvidia/cuda:${CUDA_VERSION}-devel-ubuntu16.04

ARG FFMPEG_VERSION=3.4.2
ARG CMAKE_VERSION=3.10.2

# nvcuvid deps
RUN apt-get update --fix-missing && \
    apt-get install --no-install-recommends -y libx11-6 libxext6 && rm -rf /var/lib/apt/lists/*;
ENV NVIDIA_DRIVER_CAPABILITIES=video,compute,utility

# minimal ffmpeg from source
RUN apt-get install --no-install-recommends -y yasm wget && \
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
    apt-get purge -y yasm wget && \
    apt-get autoremove -y && rm -rf /var/lib/apt/lists/*;

# video_reader build deps (pkg-config, Doxygen, recent cmake)
RUN apt-get install --no-install-recommends -y pkg-config doxygen wget && \
    cd /tmp && \
    export dir=$(echo $CMAKE_VERSION | sed "s/^\([0-9]*\.[0-9]*\).*/v\1/") && \
    wget -q https://cmake.org/files/${dir}/cmake-$CMAKE_VERSION-Linux-x86_64.sh && \
    /bin/sh cmake-$CMAKE_VERSION-Linux-x86_64.sh --skip-license --prefix=/usr/local && \
    rm cmake-$CMAKE_VERSION-Linux-x86_64.sh && \
    apt-get purge -y wget && \
    apt-get autoremove -y && rm -rf /var/lib/apt/lists/*;

# paired down OpenCV build, just enough for examples
RUN apt-get install -y wget &&
    cd /tmp && \
    wget https://github.com/opencv/opencv/archive/$OPENCV_VERSION.tar.gz && \
    tar xf $OPENCV_VERSION.tar.gz && \
    rm $OPENCV_VERSION.tar.gz && \
    cd opencv-$OPENCV_VERSION && \
    mkdir build && cd build && \
    cmake -DCUDA_GENERATION=$OPENCV_CUDA_GENERATION \
      $(for m in cudabgsegm cudacodec cudafeatures2d \
      cudafilters cudalegacy cudaoptflow cudaobjdetect \
      cudawarping cudev dnn features2d flann highgui ml \
      objdetect photo python_bindings_generator shape \
      superres ts video videoio; do echo -DBUILD_opencv_$m=OFF; done) \
      $(for f in WEBP TIFF OPENEXR JASPER; do echo -DWITH_$f=OFF; done) \
      .. && \
    make -j8 && make install && \
    ldconfig && \
    cd /tmp && rm -rf opencv-$OPENCV_VERSION && \
    apt-get purge -y wget && \
    apt-get autoremove -y

# nvidia-docker only provides libraries for runtime use, not for
# development, to hack it so we can develop inside a container (not a
# normal or supported practice), we need to make an unversioned
# symlink so gcc can find the library.  Additional, different
# nvidia-docker versions put the lib in different places, so we make
# symlinks for both places.
RUN ln -s /usr/local/nvidia/lib64/libnvcuvid.so.1 /usr/local/lib/libnvcuvid.so && \
    ln -s libnvcuvid.so.1 /usr/lib/x86_64-linux-gnu/libnvcuvid.so
