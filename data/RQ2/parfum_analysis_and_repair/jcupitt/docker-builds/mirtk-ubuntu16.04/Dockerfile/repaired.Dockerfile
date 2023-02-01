FROM ubuntu:xenial

RUN apt-get update && apt-get install --no-install-recommends -y \
	build-essential \
	unzip \
	wget \
	git \
	python \
	libssl-dev \
	pkg-config && rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/local/src

# ITK5 needs cmake 3.10+, xenial comes with 3.5
ENV CMAKE_VERSION 3.18.2
ENV CMAKE_URL https://github.com/Kitware/CMake/releases/download

RUN wget ${CMAKE_URL}/v$CMAKE_VERSION/cmake-$CMAKE_VERSION.tar.gz \
	&& tar xf cmake-${CMAKE_VERSION}.tar.gz \
	&& cd cmake-${CMAKE_VERSION} \
	&& ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
	&& make V=0 \
	&& make install && rm cmake-${CMAKE_VERSION}.tar.gz

ENV PREFIX /usr/local/mirtk
ENV BUILD_TYPE Release
# ENV BUILD_TYPE Debug
ENV MIRTK_ROOT $PREFIX
ENV PATH "$MIRTK_ROOT/bin:$PATH"
ENV LD_LIBRARY_PATH "$MIRTK_ROOT/lib:$LD_LIBRARY_PATH"
ENV PKG_CONFIG_PATH "$MIRTK_ROOT/lib/pkgconfig:$PKG_CONFIG_PATH"

# many imperial machines are missing libpng12.so.0
ARG PNG_VERSION=1.6.37
ARG PNG_URL=http://prdownloads.sourceforge.net/libpng

RUN wget ${PNG_URL}/libpng-${PNG_VERSION}.tar.gz?download -O libpng-${PNG_VERSION}.tar.gz \
	&& tar xf libpng-${PNG_VERSION}.tar.gz \
	&& cd libpng-${PNG_VERSION} \
	&& ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=${PREFIX} \
	&& make \
	&& make install && rm libpng-${PNG_VERSION}.tar.gz

COPY build-eigen.sh /usr/local/src/
RUN ./build-eigen.sh

COPY build-itk.sh /usr/local/src/
RUN ./build-itk.sh

# vtk9 really hates not having gl :(
RUN apt-get install --no-install-recommends -y \
  libgl-dev \
  libxt-dev && rm -rf /var/lib/apt/lists/*;
COPY build-vtk.sh /usr/local/src/
RUN ./build-vtk.sh

RUN apt-get install --no-install-recommends -y libgiftiio-dev libexpat1-dev libboost-dev && rm -rf /var/lib/apt/lists/*;
COPY build-mirtk.sh /usr/local/src/
RUN ./build-mirtk.sh

# we need libstc++ in our libs well, since many condor machines are
# missing the correct version, frustratingly
RUN cp /usr/lib/x86_64-linux-gnu/libstdc++* $PREFIX/lib


