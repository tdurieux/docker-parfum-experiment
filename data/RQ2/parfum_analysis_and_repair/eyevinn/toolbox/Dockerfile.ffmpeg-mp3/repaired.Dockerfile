FROM eyevinntechnology/ffmpeg-base:0.3.0
RUN apt-get install --no-install-recommends -y libmp3lame-dev && rm -rf /var/lib/apt/lists/*;
RUN cd /root/source/ffmpeg && \
  cd ffmpeg && \
  ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
    --pkg-config-flags="--static" \
    --enable-gpl \
    --enable-libfdk-aac \
    --enable-libx264 \
    --enable-libaom \
    --enable-libdav1d \
    --enable-libvpx \
    --enable-libsrt \
    --enable-libx265 \
    --enable-libfreetype \
    --enable-libopus \
    --enable-libmp3lame \
    --enable-version3 \
    --enable-openssl \
    --enable-nonfree && \
  make && \
  make install && \
  make distclean && \
  hash -r
