#==============================================================
# provision a Docker image for building lrose
# start with clean image
# install the required packages

FROM centos:8

ARG OS_TYPE=centos
ARG OS_VERSION=8

# install required packages

RUN \
    dnf install -y epel-release; \
    dnf install -y 'dnf-command(config-manager)'; \
    dnf config-manager --set-enabled powertools; \
    dnf install -y --allowerasing \
      tcsh wget git \
      emacs rsync python2 python3 mlocate \
      python2-devel platform-python-devel \
      m4 make cmake libtool autoconf automake \
      gcc gcc-c++ gcc-gfortran glibc-devel \
      libX11-devel libXext-devel libcurl-devel \
      libpng-devel libtiff-devel zlib-devel libzip-devel \
      eigen3-devel armadillo-devel \
      expat-devel libcurl-devel openmpi-devel \
      flex-devel fftw3-devel \
      bzip2-devel qt5-qtbase-devel qt5-qtdeclarative-devel \
      hdf5-devel netcdf-devel \
      GeographicLib-devel \
      xorg-x11-xauth xorg-x11-apps \
      rpm-build redhat-rpm-config \
      rpm-devel rpmdevtools; \
      alternatives --set python /usr/bin/python3;

# create link for qtmake

RUN \
    cd /usr/bin; \
    ln -s qmake-qt5 qmake;

# 32-bit libs etc for CIDD build