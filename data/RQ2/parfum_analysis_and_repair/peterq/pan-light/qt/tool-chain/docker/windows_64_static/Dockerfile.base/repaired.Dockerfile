FROM ubuntu:16.04
LABEL maintainer therecipe

RUN apt-get -qq update && apt-get --no-install-recommends -qq -y install ca-certificates git && rm -rf /var/lib/apt/lists/*;
RUN git clone -q --depth 1 https://github.com/mxe/mxe.git /usr/lib/mxe
RUN apt-get -qq update && apt-get --no-install-recommends -qq -y install autoconf automake autopoint bash bison bzip2 flex g++ g++-multilib gettext git gperf intltool libc6-dev-i386 libgdk-pixbuf2.0-dev libltdl-dev libssl-dev libtool-bin libxml-parser-perl make openssl p7zip-full patch perl pkg-config python ruby scons sed unzip wget xz-utils lzip && rm -rf /var/lib/apt/lists/*;

RUN apt-get -qq update && apt-get --no-install-recommends -qq -y install curl && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL --retry 10 --retry-delay 60 https://github.com/qt/qtbase/commit/826b09f0c507fe5321a8534054a4f0b7bdd2699b.patch > /usr/lib/mxe/src/qtbase-2-fixes.patch

RUN cd /usr/lib/mxe && make MXE_TARGETS='x86_64-w64-mingw32.static' qt5 && rm -rf /usr/lib/mxe/log && rm -rf /usr/lib/mxe/pkg
