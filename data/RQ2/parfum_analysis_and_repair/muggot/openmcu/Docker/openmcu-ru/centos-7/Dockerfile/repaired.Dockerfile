FROM centos:7

# fail if build with libvpx > 1.5

ENV NASM_VER="2.13.01" \
 MCU_CONF_OPTS="--enable-static --disable-v4l --disable-v4l2" \
 FFMPEG_VER="4.3" \
 LIBVPX_VER="1.5.0"

RUN mkdir -p /tmp/build \
 && cd /tmp/build \
 && yum install -y wget bzip2 which freetype-devel freetype \
 kernel-devel gcc gcc-c++ make patch git flex bison autoconf automake pkgconfig \
 rpm-build libtool libtool-ltdl-devel openssl-devel \
 && wget https://www.nasm.us/pub/nasm/releasebuilds/${NASM_VER}/nasm-${NASM_VER}.tar.xz \
 && tar -xvf ./nasm-${NASM_VER}.tar.xz \
 && cd nasm-${NASM_VER} \
 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && make install && cd .. \
 && git clone https://code.videolan.org/videolan/x264.git ./x264 \
 && cd ./x264 \
 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-shared && make && make install && cd .. \
 && wget https://github.com/webmproject/libvpx/archive/v${LIBVPX_VER}.tar.gz \
 && tar -xzf v${LIBVPX_VER}.tar.gz \
 && cd libvpx-${LIBVPX_VER} \
 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-shared && make && make install && cd .. \
 && wget https://ffmpeg.org/releases/ffmpeg-${FFMPEG_VER}.tar.gz \
 && tar xvfz ./ffmpeg-${FFMPEG_VER}.tar.gz \
 && cd ./ffmpeg-${FFMPEG_VER} \
 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-libx264 --enable-libvpx --enable-gpl --disable-static --enable-shared \
 && make -j 3 && make install && cd .. \
 && git clone git://github.com/muggot/openmcu.git ./openmcu-ru \
 && cd ./openmcu-ru \
 && ./autogen.sh && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" $MCU_CONF_OPTS && make -j 3 && make install \
 && rm -rf /tmp/* \
 && yum remove -y wget bzip2 which git freetype-devel flex bison autoconf automake pkgconfig \
 rpm-build libtool libtool-ltdl-devel openssl-devel \
 && yum clean all || echo "not all clean" \
 && rm -rf /var/cache/yum && rm ./nasm-${NASM_VER}.tar.xz

 EXPOSE 5060 5061 1420 1554 1720

CMD ["/opt/openmcu-ru/bin/openmcu-ru", "-x"]
