# Copyright IRT-Systemx 2018

FROM centos:7

MAINTAINER Alter Ego Engineering <luca.dallolio@aego.ai>

# https://mxe.cc/#requirements-fedora
RUN yum -y update && rpm --import http://download.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-7 && yum install -y epel-release && yum install -y autoconf automake bash bison bzip2 flex gcc-c++ gdk-pixbuf2-devel gettext git gperf intltool libtool make openssl-devel p7zip patch perl pkgconfig python ruby sed unzip wget xz git openssl lzip && rm -rf /var/cache/yum

ENV MXE_HOME=/opt/mxe
ENV MXE_BUILD=/root/mxe
ENV HOST=x86_64-w64-mingw32
ENV TARGET=${HOST}.static
WORKDIR $MXE_BUILD
RUN git clone https://github.com/mxe/mxe.git $MXE_BUILD && make PREFIX=$MXE_HOME MXE_TARGETS="$TARGET" boost hdf5 && rm -rf $MXE_BUILD && cp $MXE_HOME/$TARGET/include/lmcons.h $MXE_HOME/$TARGET/include/Lmcons.h

ENV PATH=$PATH:$MXE_HOME/bin
ENV PKG_CONFIG_PATH=$MXE_HOME/bin/$TARGET-pkg-config

ENV MED_VERSION=3.2.0
ENV MED_HOME=/root/med-${MED_VERSION}
ENV MED_BUILD=${MED_HOME}/build
WORKDIR $MED_BUILD
RUN curl -f -SL https://files.salome-platform.org/Salome/other/med-${MED_VERSION}.tar.gz | tar -xzC /root && sed -i 's#/iface:mixed_str_len_arg##' ${MED_HOME}/CMakeLists.txt && $TARGET-cmake -DCMAKE_BUILD_TYPE=Release -DSTATIC_LINKING=ON -DMEDFILE_BUILD_TESTS=OFF -DMEDFILE_BUILD_SHARED_LIBS=OFF -DMEDFILE_BUILD_STATIC_LIBS=ON -DMEDFILE_INSTALL_DOC=OFF .. && make -j && make install && rm -rf $MED_BUILD

ENV HOST=x86_64-w64-mingw32
ENV MXE_HOME=/opt/mxe
ENV TARGET=${HOST}.static
ENV PATH=$PATH:$MXE_HOME/bin:$MXE_HOME/x86_64-pc-linux-gnu/bin
ENV PKG_CONFIG_PATH=$MXE_HOME/bin/$TARGET-pkg-config
ENV WINEPREFIX=/root/.wine

ENV VEGA_SOURCE=/opt/vega
ENV VEGA_BUILD=$VEGA_SOURCE/build
COPY . $VEGA_SOURCE
WORKDIR $VEGA_BUILD
#RUN yum install -y which wine xorg-x11-server-Xvfb
#RUN Xvfb :1 -screen 0 1280x960x24 &
RUN $TARGET-cmake -DRUN_ASTER=OFF -DRUN_SYSTUS=OFF -DCMAKE_BUILD_TYPE=SDebug -DCMAKE_CROSSCOMPILING_EMULATOR=/usr/bin/wine64 .. && make -j
#RUN ctest -V .
