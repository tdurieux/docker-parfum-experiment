ARG PLATFORM=android-23
ARG TOOLCHAIN=arm-linux-androideabi-4.9

FROM rhardih/stand:r18b--$PLATFORM--$TOOLCHAIN

ARG VERSION
ARG HOST=arm-linux-androideabi
ARG PLATFORM

ENV PLATFORM $PLATFORM

RUN apt-get update && apt-get -y --no-install-recommends install \
  wget && rm -rf /var/lib/apt/lists/*;

RUN wget -O libcurl-$VERSION.tar.gz \
  https://curl.haxx.se/download/curl-$VERSION.tar.gz && \
  tar -xzvf libcurl-$VERSION.tar.gz && \
  rm libcurl-$VERSION.tar.gz

WORKDIR /curl-$VERSION

ENV PATH $PATH:/$PLATFORM-toolchain/bin

RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
	--host=$HOST \
  --prefix=/curl-build/

RUN make -j && make install
