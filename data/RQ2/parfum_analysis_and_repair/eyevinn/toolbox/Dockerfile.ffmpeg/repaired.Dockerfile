FROM ubuntu:18.04
MAINTAINER Eyevinn Technology <info@eyevinn.se>
RUN apt-get -y update
RUN apt-get install --no-install-recommends -y autoconf && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y --force-yes automake && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y --force-yes build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y --force-yes pkg-config && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y --force-yes libtool && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y --force-yes wget && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y --force-yes yasm && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y --force-yes libx264-dev && rm -rf /var/lib/apt/lists/*;
RUN mkdir /root/source
RUN mkdir /root/source/ffmpeg
RUN cd /root/source/ffmpeg && \
  wget -O fdk-aac.tar.gz https://github.com/mstorsjo/fdk-aac/tarball/master && \
  tar xzvf fdk-aac.tar.gz && \
  cd mstorsjo-fdk-aac* && \
  autoreconf -fiv && \
  ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --disable-shared && \
  make && \
  make install && \
  make distclean && rm fdk-aac.tar.gz
RUN apt-get install --no-install-recommends -y --force-yes git && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y --force-yes cmake && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y --force-yes python2.7 && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /root/source/ffmpeg/libaom && \
  cd /root/source/ffmpeg/libaom && \
  git clone https://aomedia.googlesource.com/aom && \
  cmake ./aom && \
  make && \
  make install
RUN apt-get install --no-install-recommends -y --force-yes python3 python3-pip ninja-build && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir meson
RUN apt-get install --no-install-recommends -y --force-yes nasm && rm -rf /var/lib/apt/lists/*;
RUN cd /root/source/ffmpeg && \
  git clone https://code.videolan.org/videolan/dav1d.git && \
  cd dav1d && \
  meson build --buildtype release && \
  ninja -C build && \
  ninja -C build install && \
  ldconfig
RUN apt-get install --no-install-recommends -y --force-yes libvpx-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y --force-yes libssl-dev && rm -rf /var/lib/apt/lists/*;
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y --force-yes tclsh && rm -rf /var/lib/apt/lists/*;
RUN cd /root/source/ffmpeg && \
  git clone https://github.com/Haivision/srt.git && \
  cd srt && \
  ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && \
  make && make install && \
  ldconfig
RUN apt-get install --no-install-recommends -y --force-yes libx265-dev libnuma-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y --force-yes libfreetype6-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y --force-yes libopus-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y --force-yes openssl && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y --force-yes libssl-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y --force-yes libmp3lame-dev && rm -rf /var/lib/apt/lists/*;
RUN cd /root/source/ffmpeg && \
  wget https://ffmpeg.org/releases/ffmpeg-snapshot.tar.bz2 && \
  tar xjvf ffmpeg-snapshot.tar.bz2 && \
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
  hash -r && rm ffmpeg-snapshot.tar.bz2
