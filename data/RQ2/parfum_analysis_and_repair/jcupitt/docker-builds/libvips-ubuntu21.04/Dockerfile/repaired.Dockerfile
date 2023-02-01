FROM ubuntu:21.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
  && apt-get install --no-install-recommends -y \
    build-essential \
    cmake \
    git && rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/local/src
ENV LD_LIBRARY_PATH /usr/local/lib
ENV PKG_CONFIG_PATH /usr/local/lib/pkgconfig

# install the system brotli
RUN apt-get install --no-install-recommends -y \
  libbrotli-dev && rm -rf /var/lib/apt/lists/*;

RUN git clone --depth 1 --recursive https://gitlab.com/wg1/jpeg-xl.git \
  && cd jpeg-xl \
  && mkdir build \
  && cd build \
  && cmake -G "Unix Makefiles" \
    -DCMAKE_BUILD_TYPE=Debug \
    -DCMAKE_INSTALL_PREFIX=/usr/local \
    -DBUILD_TESTING=0 \
    -DJPEGXL_ENABLE_FUZZERS=0 \
    -DJPEGXL_ENABLE_MANPAGES=0 \
    -DJPEGXL_ENABLE_BENCHMARK=0 \
    -DJPEGXL_ENABLE_EXAMPLES=0 \
    -DJPEGXL_ENABLE_SKCMS=0 \
    .. \
  && make -j$(nproc) \
  && make install

RUN apt-get install --no-install-recommends -y \
  glib-2.0-dev \
  libexpat-dev \
  librsvg2-dev \
  libpng-dev \
  libgif-dev \
  libjpeg-dev \
  libexif-dev \
  liblcms2-dev \
  liborc-dev && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y \
  autoconf \
  libtool \
  gtk-doc-tools \
  gobject-introspection && rm -rf /var/lib/apt/lists/*;

RUN git clone https://github.com/libvips/libvips \
  && cd libvips \
  && git checkout 8.10 \
  && ./autogen.sh \
  && make V=0 \
  && make install

