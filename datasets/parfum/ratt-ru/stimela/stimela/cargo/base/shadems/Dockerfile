FROM stimela/base:1.6.0
MAINTAINER <sphemakh@gmail.com>
RUN docker-apt-install python3-casacore \
    casacore-dev \
    libcfitsio-dev \
    wcslib-dev
RUN pip install -I numpy scabha
RUN pip install git+https://github.com/ratt-ru/shadeMS.git@b050
#RUN pip install git+https://github.com/o-smirnov/datashader
RUN shadems -h
