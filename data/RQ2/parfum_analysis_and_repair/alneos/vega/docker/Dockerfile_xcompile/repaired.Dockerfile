# Copyright IRT-Systemx 2018

FROM ubuntu:trusty

MAINTAINER Alter Ego Engineering <luca.dallolio@aego.ai>

# http://mxe.cc/#requirements + med requirements
# https://github.com/mxe/mxe/issues/593 and http://mxe.cc/#requirements-debian
RUN apt update && apt install --no-install-recommends -y \
    autoconf automake autopoint bash bison bzip2 flex gettext\
    git g++ gperf intltool libffi-dev libgdk-pixbuf2.0-dev \
    libtool libltdl-dev libssl-dev libxml-parser-perl make \
    openssl p7zip-full patch perl pkg-config python ruby scons \
    sed unzip wget xz-utils \
    libtool g++-multilib libc6-dev-i386 \
    make hdf5-tools curl && rm -rf /var/lib/apt/lists/*;
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

FROM ubuntu:trusty

RUN dpkg --add-architecture i386 && echo "deb http://dl.winehq.org/wine-builds/ubuntu/ trusty main" >> /etc/apt/sources.list.d/winehq.list && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 5FCBF54A && apt update && apt install --allow-unauthenticated --no-install-recommends -y winehq-stable make && rm -rf /var/lib/apt/lists/*;

WORKDIR /opt
COPY --from=0 /opt/mxe ./mxe

ENV HOST=x86_64-w64-mingw32
ENV MXE_HOME=/opt/mxe
ENV TARGET=${HOST}.static
ENV PATH=$PATH:$MXE_HOME/bin:$MXE_HOME/x86_64-pc-linux-gnu/bin
ENV PKG_CONFIG_PATH=$MXE_HOME/bin/$TARGET-pkg-config
ENV WINEPREFIX=/root/.wine

# Run as privileged, then commit this
#RUN printf "package wine\ninterpreter /usr/bin/wine\nmagic MZ" > /usr/share/binfmts/wine64 && apt install --no-install-recommends -y binfmt-support && update-binfmts --import /usr/share/binfmts/wine64

#ENV VEGA_SOURCE=/opt/vega
#COPY . $VEGA_SOURCE
#WORKDIR $VEGA_SOURCE/build
#RUN $TARGET-cmake -DTESTS_EXEC_SOLVER=0 -DCMAKE_BUILD_TYPE=SDebug .. && make -j && ctest .

