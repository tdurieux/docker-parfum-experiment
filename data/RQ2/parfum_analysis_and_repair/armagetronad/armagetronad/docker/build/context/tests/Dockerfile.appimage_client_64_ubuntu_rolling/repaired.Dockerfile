FROM ubuntu:rolling
# rolling = most recent

RUN apt-get -y update && apt-get install --no-install-recommends \
mesa-utils \
-y && rm -rf /var/lib/apt/lists/*;

COPY *.AppImage .
RUN ./*.AppImage --appimage-extract-and-run --version

RUN LD_DEBUG_APP=true ./*.AppImage --appimage-extract-and-run --version
