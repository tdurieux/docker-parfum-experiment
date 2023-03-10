FROM debian:stretch

RUN apt-get update && \
  apt-get install --no-install-recommends -y \
    autoconf \
    autotools-dev \
    binutils-mingw-w64 \
    build-essential \
    dos2unix \
    g++-mingw-w64 \
    gcc-multilib \
    git \
    libtool \
    mingw-w64-common \
    p7zip-full \
    wget && rm -rf /var/lib/apt/lists/*;

#patching ancient mingw in debian:stretch
ADD setupapi.patch .
RUN patch /usr/share/mingw-w64/include/setupapi.h < setupapi.patch

RUN mkdir /wdk
WORKDIR /wdk
ADD wdk.7z /wdk/wdk.7z
RUN 7z x wdk.7z

ADD libwdi /libwdi
WORKDIR /libwdi

# ======================= BUILD 32BIT WDI ========
RUN bash ./autogen.sh --host=i686-w64-mingw32 --with-wdkdir=/wdk/wdk/ --with-libusb0="" --with-libusbk="" --disable-64bit

#add missing COINSTALLER_DIR because of some bug in m4 with AC_CHECK_FILES and cross-compilation
RUN echo '#define COINSTALLER_DIR "wdf"' >> config.h

# actual make
RUN cd libwdi && make all-local
RUN cd examples && make wdi-simple.exe

RUN cp examples/wdi-simple.exe wdi-simple-32b.exe

# ======================= BUILD 64BIT WDI ========
RUN make clean
RUN bash ./autogen.sh --host=x86_64-w64-mingw32 --with-wdkdir=/wdk/wdk/ --with-libusb0="" --with-libusbk="" --disable-32bit

#add missing defs because of some bug in m4 with AC_CHECK_FILES and cross-compilation
RUN echo '#define COINSTALLER_DIR "wdf"' >> config.h
RUN echo '#define X64_DIR "x64"' >> config.h

# actual make
RUN cd libwdi && make all-local
RUN cd examples && make wdi-simple.exe

RUN cp examples/wdi-simple.exe wdi-simple-64b.exe
