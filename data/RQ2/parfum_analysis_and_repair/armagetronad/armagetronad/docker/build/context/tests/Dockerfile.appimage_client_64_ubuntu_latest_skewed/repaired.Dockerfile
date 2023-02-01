FROM ubuntu:latest
# latest = latest LTS

# skewed installation: add some of our dependencies, most indirect ones
RUN apt-get -y update && apt-get install --no-install-recommends \
mesa-utils \

libsdl2-2.0-0 \

libogg0 \

libpng16-16 \

libprotobuf17 \

libjpeg8 \

libvorbis0a \
libxml2 \
-y && rm -rf /var/lib/apt/lists/*;

COPY *.AppImage .
RUN ./*.AppImage --appimage-extract-and-run --version

RUN LD_DEBUG_APP=true ./*.AppImage --appimage-extract-and-run --version
