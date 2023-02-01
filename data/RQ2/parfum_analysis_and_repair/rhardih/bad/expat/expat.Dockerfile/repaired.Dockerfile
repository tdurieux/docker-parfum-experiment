ARG PLATFORM=android-23
ARG TOOLCHAIN=arm-linux-androideabi-4.9

FROM rhardih/stand:r18b--$PLATFORM--$TOOLCHAIN

ARG VERSION
ARG HOST=arm-linux-androideabi
ARG PLATFORM

ENV PLATFORM $PLATFORM

RUN apt-get update && apt-get -y --no-install-recommends install \
  wget \
  autoconf \
  libtool && rm -rf /var/lib/apt/lists/*;

# TODO: Fix R_2_2_5 explicit version dependence
RUN wget -O $VERSION.tar.bz2 \
  https://github.com/libexpat/libexpat/releases/download/R_2_2_5/expat-$VERSION.tar.bz2 && \
  tar -xjvf $VERSION.tar.bz2 && \
  rm $VERSION.tar.bz2

WORKDIR /expat-$VERSION

ENV PATH /$PLATFORM-toolchain/bin:$PATH

RUN autoreconf -vfi

RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
	--host=$HOST \
  --prefix=/expat-build/

RUN make -j && make install
