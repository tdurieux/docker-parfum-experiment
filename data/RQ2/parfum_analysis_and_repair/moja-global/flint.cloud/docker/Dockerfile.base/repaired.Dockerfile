FROM ubuntu:focal

# build args
ARG NUM_CPU=1
ARG BUILD_TYPE=RELEASE
ARG DEBIAN_FRONTEND=noninteractive

# env. variables
ENV ROOTDIR /usr/local
ENV GDAL_VERSION 3.4.1
ENV POCO_VERSION 1.11.1
ENV BOOST_VERSION 1_78_0
ENV BOOST_VERSION_DOT 1.78.0
ENV FMT_VERSION 8.1.1

ENV PATH $ROOTDIR/bin:$PATH
ENV LD_LIBRARY_PATH $ROOTDIR/lib:$LD_LIBRARY_PATH
ENV PYTHONPATH $ROOTDIR/lib:$PYTHONPATH

ENV CURL_CA_BUNDLE /etc/ssl/certs/ca-certificates.crt
ENV GDAL_DATA=/usr/local/share/gdal
ENV GDAL_HTTP_VERSION 2
ENV GDAL_HTTP_VERSION 2
ENV GDAL_HTTP_MERGE_CONSECUTIVE_RANGES YES
ENV GDAL_HTTP_MULTIPLEX YES

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

WORKDIR $ROOTDIR/

# Install basic dependencies
RUN apt-get update -y \
    && apt-get install -y --fix-missing --no-install-recommends \
      software-properties-common build-essential ca-certificates \
      git g++ make cmake libssl-dev openssl wget bash-completion nasm \
      pkg-config libtool automake  libcurl4-gnutls-dev \
      zlib1g-dev libpcre3-dev libxml2-dev libexpat-dev libxerces-c-dev \
      doxygen doxygen-latex graphviz \
  	  python3-dev python3-numpy python3-pip \
      libproj-dev libgeos-dev \
      unixodbc unixodbc-dev \
      libspatialite-dev libsqlite3-dev sqlite3 \
      libpq-dev postgresql-client-12 postgresql-server-dev-12 postgis\
    && apt-get -y autoremove \
   && apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN apt-get install -y

WORKDIR $ROOTDIR/src

# Download and install POCO C++ Libraries
RUN wget -q https://github.com/pocoproject/poco/archive/refs/tags/poco-${POCO_VERSION}-release.tar.gz \
    && tar -xzf poco-${POCO_VERSION}-release.tar.gz \
    && mkdir poco-poco-${POCO_VERSION}-release/cmake-build \
    && cd poco-poco-${POCO_VERSION}-release/cmake-build \
    && cmake -DCMAKE_BUILD_TYPE=$BUILD_TYPE \
        -DCMAKE_INSTALL_PREFIX=$ROOTDIR \
        -DPOCO_UNBUNDLED=ON \
        -DENABLE_JSON=ON \
        -DENABLE_DATA=ON \
        -DENABLE_DATA_ODBC=ON \
        -DENABLE_DATA_SQLITE=ON \
        -DENABLE_DATA_MYSQL=OFF \
        -DENABLE_ACTIVERECORD=OFF \
        -DENABLE_ACTIVERECORD_COMPILER=OFF \
        -DENABLE_ENCODINGS=OFF \
        -DENABLE_ENCODINGS_COMPILER=OFF \
        -DENABLE_XML=OFF \
        -DENABLE_MONGODB=OFF \
        -DENABLE_REDIS=OFF \
        -DENABLE_PDF=OFF \
        -DENABLE_UTIL=OFF \
        -DENABLE_NET=OFF \
        -DENABLE_NETSSL=OFF \
        -DENABLE_CRYPTO=OFF \
        -DENABLE_SEVENZIP=OFF \
        -DENABLE_ZIP=OFF \
        -DENABLE_PAGECOMPILER=OFF \
        -DENABLE_PAGECOMPILER_FILE2PAGE=OFF .. \
    && make --quiet -j $NUM_CPU \
    && make --quiet install/strip \
    && make clean \
    && cd .. && rm poco-${POCO_VERSION}-release.tar.gz

# build user-config.jam files
RUN echo "using python : 3.6 : /usr ;" > ~/user-config.jam

# Download and install Boost C++ Libraries
RUN wget -q https://boostorg.jfrog.io/artifactory/main/release/${BOOST_VERSION_DOT}/source/boost_${BOOST_VERSION}.tar.bz2 \
    && tar --bzip2 -xf boost_${BOOST_VERSION}.tar.bz2 \
    && cd boost_${BOOST_VERSION}  \
    && ./bootstrap.sh --prefix=$ROOTDIR \
    && ./b2 -d0 -j $NUM_CPU cxxstd=14 install variant=release link=shared  \
    && ./b2 clean \
    && cd $ROOTDIR/src && rm boost_${BOOST_VERSION}.tar.bz2

# Download and install FMT formatting library
RUN wget -q https://github.com/fmtlib/fmt/archive/${FMT_VERSION}.tar.gz \
    && mkdir libfmt-${FMT_VERSION} \
    && tar -xzf ${FMT_VERSION}.tar.gz -C libfmt-${FMT_VERSION} --strip-components=1 \
    && cd libfmt-${FMT_VERSION} \
    && cmake -G"Unix Makefiles" \
            -DCMAKE_BUILD_TYPE=RELEASE \
            -DCMAKE_INSTALL_PREFIX=$ROOTDIR \
            -DFMT_DOC=OFF \
            -DFMT_TEST=OFF . \
    && make --quiet -j $NUM_CPU install/strip \
    && make clean \
    && cd $ROOTDIR/src && rm ${FMT_VERSION}.tar.gz

# Download and install GDAL
RUN wget -q https://download.osgeo.org/gdal/${GDAL_VERSION}/gdal-${GDAL_VERSION}.tar.gz \
    && tar -xvf gdal-${GDAL_VERSION}.tar.gz && cd gdal-${GDAL_VERSION} \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
        --without-libtool \
        --with-hide-internal-symbols \
        --with-python \
        --with-spatialite \
        --with-pg \
        --with-curl \
        --prefix=$ROOTDIR \
        --with-libtiff=internal \
        --with-rename-internal-libtiff-symbols \
        --with-geotiff=internal \
        --with-rename-internal-libgeotiff-symbols \
    && make --quiet -j $NUM_CPU \
    && make install \
    && make clean \
    && cd $ROOTDIR/src && rm gdal-${GDAL_VERSION}.tar.gz

RUN strip -s $ROOTDIR/lib/libgdal.so
RUN for i in $ROOTDIR/lib/python3/dist-packages/osgeo/*.so; do strip -s $i 2>/dev/null || /bin/true; done
RUN strip -s $ROOTDIR/bin/gdal_contour \
    && strip -s $ROOTDIR/bin/gdal_grid \
    && strip -s $ROOTDIR/bin/gdal_rasterize \
    && strip -s $ROOTDIR/bin/gdal_translate \
    && strip -s $ROOTDIR/bin/gdaladdo \
    && strip -s $ROOTDIR/bin/gdalbuildvrt \
    && strip -s $ROOTDIR/bin/gdaldem \
    && strip -s $ROOTDIR/bin/gdalenhance \
    && strip -s $ROOTDIR/bin/gdalinfo \
    && strip -s $ROOTDIR/bin/gdallocationinfo \
    && strip -s $ROOTDIR/bin/gdalmanage \
    && strip -s $ROOTDIR/bin/gdalsrsinfo \
    && strip -s $ROOTDIR/bin/gdaltindex \
    && strip -s $ROOTDIR/bin/gdaltransform \
    && strip -s $ROOTDIR/bin/gdalwarp \
    && strip -s $ROOTDIR/bin/gnmanalyse \
    && strip -s $ROOTDIR/bin/gnmmanage \
    && strip -s $ROOTDIR/bin/nearblack \
    && strip -s $ROOTDIR/bin/ogr2ogr \
    && strip -s $ROOTDIR/bin/ogrinfo \
    && strip -s $ROOTDIR/bin/ogrlineref \
    && strip -s $ROOTDIR/bin/ogrtindex

RUN apt-get update -y \
    && apt-get remove -y --purge build-essential \
    && cd $ROOTDIR/src/gdal-${GDAL_VERSION}/swig/python \
    && python3 setup.py build \
    && python3 setup.py install

# Download and install C++ wrapper around minizip compression library
RUN	git clone --recursive https://github.com/sebastiandev/zipper.git \
    && mkdir zipper/build \
    && cd zipper/build \
  	&& cmake .. \
  	&& make --quiet -j $NUM_CPU \
    && make --quiet install \
    && make clean \
    && cd $ROOTDIR/src

RUN ldconfig
RUN rm -r $ROOTDIR/src/*
