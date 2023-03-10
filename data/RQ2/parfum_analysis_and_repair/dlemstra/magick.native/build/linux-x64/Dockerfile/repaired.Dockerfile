FROM ubuntu:16.04

RUN mkdir /build && mkdir /build/libraries && mkdir /build/shared && mkdir /build/linux-x64

COPY build/linux-x64/install.dependencies.sh /build/linux-x64

RUN cd /build/linux-x64; ./install.dependencies.sh

COPY src/ImageMagick /ImageMagick

RUN cd /ImageMagick; ./checkout.sh linux

COPY build/libraries/*.sh /build/libraries

COPY build/linux-x64/settings.sh /build/linux-x64

COPY build/linux-x64/build.libraries.sh /build/linux-x64

RUN cd /ImageMagick/libraries; /build/linux-x64/build.libraries.sh /build/libraries

COPY build/shared/build.ImageMagick.sh /build/shared

ARG OpenMP

RUN cd /ImageMagick/libraries; /build/shared/build.ImageMagick.sh linux x64 ${OpenMP}

COPY src/Magick.Native /Magick.Native

COPY build/shared/build.Native.sh /build/shared

RUN cd /Magick.Native; /build/shared/build.Native.sh linux x64 $OpenMP

COPY build/shared/copy.Native.sh /build/shared