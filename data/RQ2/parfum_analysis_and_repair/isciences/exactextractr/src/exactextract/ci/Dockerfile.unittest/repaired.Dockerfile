FROM debian:buster-slim

RUN apt-get update && apt-get install --no-install-recommends -y \
  build-essential \
  cmake \
  curl \
  git \
  lcov \
  valgrind \
  wget && rm -rf /var/lib/apt/lists/*;

ARG GEOS_VERSION
ARG BUILD_TOOL

RUN wget https://download.osgeo.org/geos/geos-${GEOS_VERSION}.tar.bz2 && \
    tar -xjf geos-${GEOS_VERSION}.tar.bz2 && \
    cd geos-${GEOS_VERSION} && \
    if [ "${BUILD_TOOL}" = "cmake" ] ;then \ 
      mkdir cmake-build-release && \
      cd cmake-build-release && \
      cmake -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=YES .. ; \
    else ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"; fi && \
    make && make install && \
    cd / && \
    rm -rf geos-${GEOS_VERSION} && \
    rm geos-${GEOS_VERSION}.tar.bz2

RUN ldconfig
