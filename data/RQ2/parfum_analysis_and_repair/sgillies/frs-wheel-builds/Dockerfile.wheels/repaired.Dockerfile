# An image for building manylinux1 wheels equivalent to those that
# https://github.com/sgillies/frs-wheel-builds makes for macosx.
#
# Note well: a very limited set of format drivers are included in these
# wheels. See the GDAL configuration below for details.

FROM quay.io/pypa/manylinux1_x86_64

RUN sed -i 's/enabled=1/enabled=0/' /etc/yum/pluginconf.d/fastestmirror.conf \
    && sed -i 's/mirrorlist/#mirrorlist/' /etc/yum.repos.d/CentOS-Base.repo \
    && sed -i 's|#baseurl=http://mirror.centos.org/centos/$releasever|baseurl=http://vault.centos.org/5.11|' /etc/yum.repos.d/CentOS-Base.repo \
    && sed -i 's/^/#/' /etc/yum.repos.d/libselinux.repo

RUN yum update -y && yum install -y json-c-devel zlib-devel libtiff-devel && rm -rf /var/cache/yum

# Install openssl
RUN mkdir -p /src \
    && cd /src \
    && curl -f -L -O https://www.openssl.org/source/openssl-1.0.2o.tar.gz \
    && echo "ec3f5c9714ba0fd45cb4e087301eb1336c317e0d20b575a125050470e8089e4d  openssl-1.0.2o.tar.gz" > checksum \
    && sha256sum -c checksum \
    && tar zxf openssl-1.0.2o.tar.gz \
    && cd /src/openssl-1.0.2o \
    && ./config no-shared no-ssl2 no-async -fPIC -O2 \
    && make \
    && make install \
    && rm -rf /src && rm openssl-1.0.2o.tar.gz

# Install curl
RUN mkdir -p /src \
    && cd /src \
    && curl -f -L -O http://curl.askapache.com/download/curl-7.51.0.tar.bz2 \
    && tar jxf curl-7.51.0.tar.bz2 \
    && cd /src/curl-7.51.0 \
    && LIBS=-ldl CFLAGS="-O2" ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --with-ssl=/usr/local/ssl \
    && make \
    && make install \
    && rm -rf /src && rm curl-7.51.0.tar.bz2

# Install geos
RUN mkdir -p /src \
    && cd /src \
    && curl -f -L -O http://download.osgeo.org/geos/geos-3.6.2.tar.bz2 \
    && tar jxf geos-3.6.2.tar.bz2 \
    && cd /src/geos-3.6.2 \
    && CFLAGS="-O2" CXXFLAGS="-O2" ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
    && make \
    && make install \
    && rm -rf /src && rm geos-3.6.2.tar.bz2

# proj4
RUN mkdir -p /src \
    && cd /src \
    && curl -f -L -O http://download.osgeo.org/proj/proj-4.9.3.tar.gz \
    && tar xzf proj-4.9.3.tar.gz \
    && cd /src/proj-4.9.3 \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" CFLAGS="-O2" \
    && make \
    && make install \
    && rm -rf /src && rm proj-4.9.3.tar.gz

# cmake
RUN cd /usr/local/src \
    && curl -f -L -O http://www.cmake.org/files/v3.9/cmake-3.9.1.tar.gz \
    && tar xzf cmake-3.9.1.tar.gz \
    && cd cmake-3.9.1 \
    && ./bootstrap --prefix=/usr/local/cmake \
    && make; rm cmake-3.9.1.tar.gz make install

# openjpeg
RUN mkdir -p /src \
    && cd /src \
    && curl -f -L -O https://github.com/uclouvain/openjpeg/archive/v2.3.0.tar.gz \
    && tar xzf v2.3.0.tar.gz \
    && cd /src/openjpeg-2.3.0 \
    && mkdir -p build \
    && cd build \
    && /usr/local/cmake/bin/cmake .. -DBUILD_THIRDPARTY:BOOL=ON -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local \
    && make install \
    && make clean \
    && rm -rf /src && rm v2.3.0.tar.gz

# hdf
RUN cd /usr/local/src \
    && curl -f -L -O https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.10/hdf5-1.10.1/src/hdf5-1.10.1.tar.gz \
    && tar xzf hdf5-1.10.1.tar.gz \
    && cd hdf5-1.10.1 \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr/local --enable-shared --enable-build-mode=production CFLAGS="-O2" \
    && make \
    && make install && rm hdf5-1.10.1.tar.gz

## netcdf
RUN cd /usr/local/src \
    && curl -f -L -O ftp://ftp.unidata.ucar.edu/pub/netcdf/netcdf-4.4.1.1.tar.gz \
    && tar xzf netcdf-4.4.1.1.tar.gz \
    && cd netcdf-4.4.1.1 \
    && CFLAGS="-I/usr/local/include -O2" CXXFLAGS="-I/usr/local/include -O2" LDFLAGS="-L/usr/local/lib" ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
    && make \
    && make install && rm netcdf-4.4.1.1.tar.gz

## expat
RUN cd /usr/local/src \
    && curl -f -L -O https://github.com/libexpat/libexpat/releases/download/R_2_2_5/expat-2.2.5.tar.bz2 \
    && tar xjf expat-2.2.5.tar.bz2 \
    && cd expat-2.2.5 \
    && CFLAGS="-O2" ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr/local \
    && make \
    && make install && rm expat-2.2.5.tar.bz2

## webp
RUN cd /usr/local/src \
    && curl -f -L -O https://storage.googleapis.com/downloads.webmproject.org/releases/webp/libwebp-0.6.1.tar.gz \
    && tar xzf libwebp-0.6.1.tar.gz \
    && cd libwebp-0.6.1 \
    && CFLAGS="-O2" ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr/local \
    && make \
    && make install && rm libwebp-0.6.1.tar.gz

# gdal
RUN cd /usr/local/src \
    && curl -f -L -O http://download.osgeo.org/gdal/2.2.4/gdal-2.2.4.tar.gz \
    && tar xzf gdal-2.2.4.tar.gz \
    && cd gdal-2.2.4 \
    && CFLAGS="-O2" CXXFLAGS="-O2" ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
        --with-threads \
        --disable-debug \
        --disable-static \
        --without-grass \
        --without-libgrass \
        --without-jpeg12 \
        --with-libtiff \
        --with-jpeg \
        --with-gif \
        --with-png \
        --with-webp \
        --with-geotiff=internal \
        --with-pcraster=internal \
        --with-pcraster=internal \
        --with-pcidsk=internal \
        --with-bsb \
        --with-grib \
        --with-pam \
        --with-geos=/usr/local/bin/geos-config \
        --with-static-proj4=/usr/local \
        --with-expat=/usr/local \
        --with-sqlite3 \
        --with-libjson-c \
        --with-libiconv-prefix=/usr \
        --with-libz=/usr \
        --with-curl=/usr/local/bin/curl-config \
        --with-netcdf=/usr/local \
        --with-openjpeg \
        --without-jasper \
        --without-python \
    && make \
    && make install && rm gdal-2.2.4.tar.gz

# Bake dev requirements into the Docker image for faster builds
RUN for PYBIN in /opt/python/*/bin; do \
        if [[ $PYBIN == *"26"* ]]; then continue; fi ; \
        curl -f https://bootstrap.pypa.io/get-pip.py | python; \
        $PYBIN/pip install -U pip ; \
        $PYBIN/pip install cython "numpy>=1.11" --only-binary cython,numpy ; \
    done

WORKDIR /io
CMD ["/io/build-linux-wheels.sh"]
