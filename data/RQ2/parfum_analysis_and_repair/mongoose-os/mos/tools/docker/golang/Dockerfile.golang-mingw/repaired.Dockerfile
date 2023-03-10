FROM docker.io/mgos/ubuntu-golang:focal

RUN apt-get install -y --no-install-recommends \
        mingw-w64 p7zip && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

# Add precompiled Windows libusb.
# 1.0.23 is chosen to match libusb version shipped with ubuntu:bionic, which is where the headers come from.
RUN mkdir /opt/libusb-win && cd /opt/libusb-win && \
    wget -q https://downloads.sourceforge.net/project/libusb/libusb-1.0/libusb-1.0.23/libusb-1.0.23.7z && \
    p7zip -d libusb-*.7z && \
    cp MinGW32/static/libusb-1.0.a /usr/i686-w64-mingw32/lib && \
    rm -rf /opt/libusb-win
