ARG PLATFORM=android-23
ARG TOOLCHAIN=arm-linux-androideabi-4.9

FROM rhardih/stand:r18b--$PLATFORM--$TOOLCHAIN

ARG PLATFORM
ENV PLATFORM $PLATFORM
ARG HOST=arm-linux-androideabi

# List of available versions can be found at
# http://download.osgeo.org/geos/
ARG VERSION

RUN apt-get update && apt-get -y --no-install-recommends install \
  wget \
  bzip2 && rm -rf /var/lib/apt/lists/*;

RUN wget -O geos-$VERSION.tar.bz2 \
  https://download.osgeo.org/geos/geos-$VERSION.tar.bz2 && \
  tar -xjvf geos-$VERSION.tar.bz2 && \
  rm geos-$VERSION.tar.bz2

WORKDIR /geos-$VERSION

ENV PATH $PATH:/$PLATFORM-toolchain/bin
ENV CXXFLAGS -std=c++11

RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
  --host=$HOST \
  --prefix=/geos-build/

RUN make -j && make install

