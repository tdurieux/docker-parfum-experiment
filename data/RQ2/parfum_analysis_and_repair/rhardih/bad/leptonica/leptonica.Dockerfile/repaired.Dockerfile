ARG PLATFORM=android-23
ARG TOOLCHAIN=arm-linux-androideabi-4.9
ARG ARCH=armv7-a

FROM bad-tiff:4.0.10-$ARCH AS tiff-dep

FROM rhardih/stand:r18b--$PLATFORM--$TOOLCHAIN

# Copy value of platform into final environment
ARG PLATFORM
ENV PLATFORM $PLATFORM

ARG VERSION
ARG HOST=arm-linux-androideabi

COPY --from=tiff-dep /tiff-build /tiff-build

RUN apt-get update && apt-get -y --no-install-recommends install \
  wget \
  automake \
  libtool \
  pkg-config && rm -rf /var/lib/apt/lists/*;

RUN wget -O $VERSION.tar.gz \
  https://github.com/DanBloomberg/leptonica/archive/$VERSION.tar.gz && \
  tar -xzvf $VERSION.tar.gz && \
  rm $VERSION.tar.gz

WORKDIR /leptonica-$VERSION

ENV PATH $PATH:/$PLATFORM-toolchain/bin

ENV LIBTIFF_LIBS -L/tiff-build/lib -ltiff
ENV LIBTIFF_CFLAGS -I/tiff-build/include

RUN ./autobuild

RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
  --host=$HOST \
  --disable-programs \
  --without-zlib \
  --without-libpng \
  --without-jpeg \
  --without-giflib \
  --without-libwebp \
  --without-libopenjpeg \
  --prefix=/leptonica-build/

RUN make -j && make install
