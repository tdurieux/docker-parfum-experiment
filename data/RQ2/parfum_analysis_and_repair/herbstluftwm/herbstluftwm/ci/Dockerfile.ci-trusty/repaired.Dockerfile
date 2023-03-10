FROM ubuntu:trusty-20190122

# Add i386 so that we can build with -m32 to catch more portability errors:
RUN dpkg --add-architecture i386

# Build deps
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -y install \
    ccache \
    cmake3 \
    g++-4.8-multilib \
    gcc-4.8-multilib \
    libx11-dev:i386 \
    libxext-dev:i386 \
    libxft-dev:i386 \
    libfreetype6-dev:i386 \
    libxinerama-dev:i386 \
    libxml2-utils \
    libxrandr-dev:i386 \
    libxfixes-dev:i386 \
    ninja-build \
    pkg-config:i386 \
    xterm \
    xvfb \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*.deb
