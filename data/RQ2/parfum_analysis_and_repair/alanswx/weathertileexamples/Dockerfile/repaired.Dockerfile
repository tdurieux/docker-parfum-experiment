FROM ubuntu:latest

# Update Ubuntu Software repository
RUN apt-get update && apt-get install --no-install-recommends -y software-properties-common wget && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:ubuntugis/ppa && apt-get update

RUN apt-get install --no-install-recommends -y gdal-bin libgdal-dev gfortran && rm -rf /var/lib/apt/lists/*;

ENV CPLUS_INCLUDE_PATH=/usr/include/gdal
ENV C_INCLUDE_PATH=/usr/include/gdal

RUN apt-get install --no-install-recommends -y python-pip python3-gdal python3-numpy curl && rm -rf /var/lib/apt/lists/*;


RUN curl -f -o wgrib2.tar.gz "ftp://ftp.cpc.ncep.noaa.gov/wd51we/wgrib2/wgrib2.tgz.v2.0.2"
#RUN curl -o wgrib2.tar.gz "ftp://ftp.cpc.ncep.noaa.gov/wd51we/wgrib2/wgrib2.tgz.v2.0.8"

ENV FC=gfortran

RUN tar zxf wgrib2.tar.gz && cd grib2 &&  make && cp wgrib2/wgrib2 /usr/bin/wgrib2 && rm wgrib2.tar.gz
