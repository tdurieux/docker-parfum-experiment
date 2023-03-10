FROM stimela/base:1.6.0
MAINTAINER <sphemakh@gmail.com>
RUN docker-apt-install libboost-dev \
    casacore-dev \
    gfortran
RUN pip install --no-cache-dir -U six numpy
RUN pip install --no-cache-dir katdal[ms,s3]
RUN export NUMBA_CACHE_DIR=/dat
RUN mvftoms.py -h
RUN python --version

