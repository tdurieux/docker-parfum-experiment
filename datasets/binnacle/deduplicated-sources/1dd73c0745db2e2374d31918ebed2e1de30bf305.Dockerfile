FROM debian:latest

RUN apt-get update && apt-get install -y \
  build-essential \
  cmake \
  unzip \
  wget

# Use dbaston branch below that preserves necessary GEOS_VERSION defines
RUN wget https://github.com/dbaston/libgeos/archive/trac-882.zip -O geos.zip && \
    unzip geos.zip && \
    mkdir /geos-build && \
    cd /geos-build && \
    cmake ../libgeos-trac-882 && \
    make -j4 && \
    make install && \
    cd / && \
    rm -rf /geos-build && \
    rm -rf /libgeos-trac-882 && \
    rm /geos.zip && \
    ldconfig
  
