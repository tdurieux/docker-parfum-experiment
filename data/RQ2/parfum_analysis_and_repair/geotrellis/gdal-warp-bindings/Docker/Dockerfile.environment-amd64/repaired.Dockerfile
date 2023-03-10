FROM quay.io/geotrellis/gdal-warp-bindings-crossbuild:amd64-2
LABEL maintainer="Azavea <info@azavea.com>"

RUN apt-get update -y && \
    apt-get install --no-install-recommends build-essential pkg-config openjdk-8-jdk -y -q && \
    apt-get autoremove && \
    apt-get autoclean && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

# Install SQLite
RUN apt-get install --no-install-recommends -y sqlite3 libsqlite3-dev && rm -rf /var/lib/apt/lists/*;

# Build GDAL 3.1.2
RUN cd /usr/local/src && \
    wget -k 'https://download.osgeo.org/gdal/3.1.2/gdal-3.1.2.tar.gz' && \
    wget -k 'https://download.osgeo.org/proj/proj-7.1.0.tar.gz' && \
    wget -k 'https://download.osgeo.org/libtiff/tiff-4.1.0.tar.gz' && \
    wget -k 'https://curl.haxx.se/download/curl-7.71.1.tar.gz' && \
    tar axvf gdal-3.1.2.tar.gz && tar axvf proj-7.1.0.tar.gz && tar axvf tiff-4.1.0.tar.gz && tar axvf curl-7.71.1.tar.gz && \
    cd curl-7.71.1 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr/local && nice -n 19 make -j33 && make install && \
    cd ../tiff-4.1.0 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr/local && nice -n 19 make -j33 && make install && \
    cd ../proj-7.1.0 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr/local && nice -n 19 make -j33 && make install && \
    cd ../gdal-3.1.2 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr/local && nice -n 19 make -j33 && make install && \
    cd .. && rm -r curl-7.71.1/ tiff-4.1.0/ proj-7.1.0/ gdal-3.1.2/ curl-7.71.1.tar.gz tiff-4.1.0.tar.gz proj-7.1.0.tar.gz gdal-3.1.2.tar.gz

# Test data
RUN wget 'https://download.osgeo.org/geotiff/samples/usgs/c41078a1.tif' -k -O /tmp/c41078a1.tif

# Boost
RUN wget 'https://boostorg.jfrog.io/artifactory/main/release/1.69.0/source/boost_1_69_0.tar.bz2' -O /tmp/boost.tar.bz2 && \
  mkdir -p /usr/local/include && \
  cd /usr/local/include && \
  tar axvf /tmp/boost.tar.bz2 && \
  rm /tmp/boost.tar.bz2

# Macintosh
RUN mkdir -p /macintosh && \
    cd /macintosh && \
    wget "https://github.com/AdoptOpenJDK/openjdk8-binaries/releases/download/jdk8u202-b08/OpenJDK8U-jdk_x64_mac_hotspot_8u202b08.tar.gz" && \
    tar axvf OpenJDK8U-jdk_x64_mac_hotspot_8u202b08.tar.gz && \
    rm -f OpenJDK8U-jdk_x64_mac_hotspot_8u202b08.tar.gz && \
    wget "https://anaconda.org/conda-forge/libgdal/3.1.2/download/osx-64/libgdal-3.1.2-hd7bf8dc_4.tar.bz2" && \
    mkdir -p gdal/3.1.2 && \
    tar axvf libgdal-3.1.2-hd7bf8dc_4.tar.bz2 -C gdal/3.1.2 && \
    rm -f libgdal-3.1.2-hd7bf8dc_4.tar.bz2

# Windows
RUN mkdir -p /windows && \
    cd /windows && \
    wget "https://github.com/AdoptOpenJDK/openjdk8-binaries/releases/download/jdk8u202-b08/OpenJDK8U-jdk_x64_windows_hotspot_8u202b08.zip" && \
    unzip OpenJDK8U-jdk_x64_windows_hotspot_8u202b08.zip && \
    rm -r OpenJDK8U-jdk_x64_windows_hotspot_8u202b08.zip && \
    mkdir -p /windows/gdal && \
    cd /windows/gdal && \
    wget "https://download.gisinternals.com/sdk/downloads/release-1911-x64-gdal-3-0-4-mapserver-7-4-3-libs.zip" && \
    unzip release-1911-x64-gdal-3-0-4-mapserver-7-4-3-libs.zip && \
    rm -f release-1911-x64-gdal-3-0-4-mapserver-7-4-3-libs.zip

# Linkage
RUN echo '/usr/local/lib' >> /etc/ld.so.conf && ldconfig

# docker build -f Dockerfile.environment-amd64 -t quay.io/geotrellis/gdal-warp-bindings-environment:amd64-2 .
