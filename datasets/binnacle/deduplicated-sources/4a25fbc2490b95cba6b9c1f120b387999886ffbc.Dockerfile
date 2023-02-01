ARG BASE_IMAGE

FROM ${BASE_IMAGE} AS debian-stretch-build

RUN apt-get update

# Build foundation and header files
RUN apt-get install --yes --no-install-recommends \
    apt-utils git nano \
    build-essential pkg-config libssl-dev libffi-dev libyaml-dev libpng-dev libfreetype6-dev \
    python python-dev python-setuptools python-virtualenv virtualenv

# Scipy, Numpy, Matplotlib and PyTables
RUN apt-get install --yes --install-recommends \
    python-requests python-openssl python-cryptography python-numpy python-scipy python-matplotlib python-tables python-netcdf4

#RUN apt-get install --yes --no-install-recommends \
#    gfortran libatlas-dev libopenblas-dev liblapack-dev libcoarrays-dev \
#    libhdf5-dev libnetcdf-dev liblzo2-dev libbz2-dev \


FROM debian-stretch-build

# FPM
RUN apt-get install --yes --no-install-recommends \
    ruby ruby-dev && \
    gem install fpm --version 1.11.0
