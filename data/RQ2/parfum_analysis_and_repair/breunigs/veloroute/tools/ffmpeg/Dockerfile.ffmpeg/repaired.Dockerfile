FROM debian:testing-slim AS downloader

ARG RAV1E_VERSION=p20220531
ARG FFMPEG_VERSION=5.0
ARG BLUR_VERSION=1f77efa7947bd25a0e2fe6a1b632c832b7c4f033

RUN mkdir -p /downloads/

RUN  \
  apt-get update && \
  apt-get install -y --no-install-recommends \
  ca-certificates \
  wget \
  && rm -rf /var/lib/apt/lists/*

RUN \
  cd /downloads/ && \
  wget https://github.com/xiph/rav1e/archive/refs/tags/${RAV1E_VERSION}.tar.gz -O rav1e.tar.gz && \
  tar zxf rav1e.tar.gz && rm rav1e.tar.gz && mv rav1e* rav1e

RUN \
  cd /downloads/ && \
  wget https://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.gz -O ffmpeg.tar.gz && \
  tar zxf ffmpeg.tar.gz && rm ffmpeg.tar.gz && mv ffmpeg-${FFMPEG_VERSION} ffmpeg

RUN cd /downloads/ && \
  wget https://github.com/breunigs/frei0r-blur-from-json/archive/${BLUR_VERSION}.tar.gz && \
  tar zxf ${BLUR_VERSION}.tar.gz && rm ${BLUR_VERSION}.tar.gz && mv frei0r-blur-from-json-${BLUR_VERSION} blur

FROM debian:testing-slim AS blur
WORKDIR /build/

RUN apt-get update \
  && apt-get install --yes --no-install-recommends \
  cmake \
  frei0r-plugins-dev \
  g++ \
  libboost-dev \
  libboost-iostreams-dev \
  libvips-dev \
  make \
  && rm -rf /var/lib/apt/lists/*

COPY --from=downloader /downloads/blur/ /build/.
RUN cmake . && make


FROM debian:testing-slim AS ffmpeg-build

RUN \
  apt-get update \
  && apt-get install -y --no-install-recommends \
  autoconf \
  automake \
  binutils \
  build-essential \
  ca-certificates \
  cargo \
  cmake \
  curl \
  frei0r-plugins-dev \
  git \
  libdav1d-dev \
  libffmpeg-nvenc-dev \
  libssl-dev \
  libtool \
  libva-dev \
  libvpx-dev \
  libwebp-dev \
  libx264-dev \
  libx265-dev \
  libzimg-dev \
  make \
  meson \
  nasm \
  ninja-build \
  opencl-dev \
  pkg-config \
  yasm \
  && echo "deb http://deb.debian.org/debian unstable main" >> /etc/apt/sources.list \
  && apt-get update \
  && apt-get install -y --no-install-recommends -t unstable rustc \
  && rm -rf /var/lib/apt/lists/* \
  && cargo install cargo-c

ENV PREFIX=/build
RUN mkdir ${PREFIX}
ENV CFLAGS=-O3
ENV CXXFLAGS="$CFLAGS"
ENV LDFLAGS="$LDFLAGS -L${PREFIX}/lib"
ENV LD_LIBRARY_PATH="${PREFIX}/lib"
ENV PKG_CONFIG_PATH="${PREFIX}/lib/pkgconfig"

COPY --from=downloader /downloads /downloads/

RUN cd /downloads/rav1e && \
  RUSTFLAGS="-C target-cpu=native" cargo cinstall --release --prefix ${PREFIX} --library-type staticlib

RUN cd /downloads/ffmpeg && \
  ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
  --prefix="${PREFIX}" \
  --extra-libs="-lm -lpthread" \
  --extra-cflags="-I${PREFIX}/include -w -O3" \
  --extra-ldflags="-L${PREFIX}/lib" \
  --ld="g++" \
  --enable-version3 \
  --enable-gpl \
  --enable-frei0r \
  --enable-libdav1d \
  --enable-librav1e \
  --enable-libvpx \
  --enable-libwebp \
  --enable-libx264 \
  --enable-libx265 \
  --enable-libzimg \
  --enable-opencl \
  --enable-vaapi \
  --disable-debug \
  --disable-doc \
  --disable-ffplay \
  --disable-ffprobe && \
  make -j $(nproc) && make install && make distclean


FROM debian:testing-slim AS runner
RUN \
  apt-get update && \
  apt-get install -y --no-install-recommends \
  i965-va-driver \
  libboost-iostreams1.74.0 \
  libdav1d[0-9]+ \
  libva-drm2 \
  libva2 \
  libvips42 \
  libvpx7 \
  libwebp[0-9]+ \
  libwebpmux3 \
  libx264-[0-9]+ \
  libx265-[0-9]+ \
  libzimg2 \
  mesa-opencl-icd \
  ocl-icd-libopencl1 \
  ocl-icd-opencl-dev \
  && rm -rf /var/lib/apt/lists/*

RUN \
  echo "deb http://deb.debian.org/debian unstable main" >> /etc/apt/sources.list && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
  beignet-opencl-icd \
  && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /usr/lib/frei0r-1/
COPY --from=blur /build/jsonblur.so /usr/lib/frei0r-1/
COPY --from=ffmpeg-build /build/bin/ffmpeg /usr/bin/
WORKDIR /workdir

ARG RENDER_GID
ARG GID
ARG UID
RUN addgroup --gid ${RENDER_GID} render && \
  addgroup --gid ${GID} dummy && \
  useradd -s /bin/bash -G render,video -g ${GID} -u ${UID} dummy
USER dummy

CMD ["/usr/bin/ffmpeg"]
