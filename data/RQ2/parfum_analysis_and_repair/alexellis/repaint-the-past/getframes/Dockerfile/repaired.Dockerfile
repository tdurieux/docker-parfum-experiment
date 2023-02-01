FROM python:2.7
RUN apt-get update -qy \
  && apt-get install --no-install-recommends -qy \
     nano wget build-essential libmp3lame-dev \
     libvorbis-dev libtheora-dev libspeex-dev \
     yasm pkg-config libopenjpeg-dev libx264-dev libav-tools && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir numpy \
    && pip install --no-cache-dir opencv-python scikit-video

WORKDIR /root
RUN wget https://ffmpeg.org/releases/ffmpeg-3.4.tar.bz2 \
    && tar xvjf ffmpeg-3.4.tar.bz2 && rm ffmpeg-3.4.tar.bz2

WORKDIR /root/ffmpeg-3.4

RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-gpl --enable-postproc --enable-swscale --enable-avfilter --enable-libmp3lame \
  --enable-libvorbis --enable-libtheora --enable-libx264 --enable-libspeex --enable-shared --enable-pthreads \
  --enable-libopenjpeg --enable-nonfree \
    && make -j 4 \
    && make install \
    && /sbin/ldconfig

WORKDIR /tmp/

CMD ["/bin/bash"]
