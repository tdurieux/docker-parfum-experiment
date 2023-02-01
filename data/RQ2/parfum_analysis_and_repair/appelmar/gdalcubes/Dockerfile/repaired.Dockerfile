FROM ubuntu:focal
MAINTAINER Marius Appel <marius.appel@uni-muenster.de>
ARG DEBIAN_FRONTEND="noninteractive"

RUN apt-get update && apt-get install --no-install-recommends -y software-properties-common libboost-all-dev cmake g++ libsqlite3-dev git supervisor wget && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libnetcdf-dev libcurl4-openssl-dev libcpprest-dev doxygen graphviz && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libxml2-dev libopenjp2-7-dev libhdf4-alt-dev libgdal-dev gdal-bin libproj-dev && rm -rf /var/lib/apt/lists/*;


COPY $PWD /opt/gdalcubes
RUN cd /opt/gdalcubes && mkdir -p build && cd build && cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release ../ && make -j 2 && make install

COPY supervisord.conf /opt/supervisord.conf

EXPOSE 1111
CMD ["/usr/bin/supervisord", "-c", "/opt/supervisord.conf"]


# docker build -t appelmar/gdalcubes .
# docker run -d -p 11111:1111 appelmar/gdalcubes