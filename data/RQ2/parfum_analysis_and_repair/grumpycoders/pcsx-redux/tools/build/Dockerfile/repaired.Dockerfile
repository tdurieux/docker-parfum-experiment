# Dockerfile for grumpycoders/pcsx-redux-build

FROM ubuntu:22.04

# The tzdata package isn't docker-friendly, and something pulls it.
ENV DEBIAN_FRONTEND noninteractive
ENV TZ Etc/GMT

RUN apt update
RUN apt dist-upgrade -y

# Utility packages
RUN apt install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y make && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y pkg-config && rm -rf /var/lib/apt/lists/*;

# Compilers & base libraries
RUN apt install --no-install-recommends -y g++-12 && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y g++-mipsel-linux-gnu && rm -rf /var/lib/apt/lists/*;

# Development packages
RUN apt install --no-install-recommends -y libavcodec-dev && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y libavformat-dev && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y libavutil-dev && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y libcapstone-dev && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y libcurl4-openssl-dev && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y libfreetype-dev && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y libglfw3-dev && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y libswresample-dev && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y libuv1-dev && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y zlib1g-dev && rm -rf /var/lib/apt/lists/*;

# CI utilities
RUN apt install --no-install-recommends -y curl wget && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y xvfb && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y python3-pip python3-setuptools patchelf desktop-file-utils libgdk-pixbuf2.0-dev fakeroot strace && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y glibc-tools lcov && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y file && rm -rf /var/lib/apt/lists/*;
WORKDIR /tmp
RUN wget https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage && \
    chmod +x /tmp/appimagetool-x86_64.AppImage && \
    cd /opt && /tmp/appimagetool-x86_64.AppImage --appimage-extract && \
    mv squashfs-root appimage-tool.AppDir && \
    ln -s /opt/appimage-tool.AppDir/AppRun /usr/bin/appimagetool && \
    rm /tmp/appimagetool-x86_64.AppImage
WORKDIR /
RUN pip3 install --no-cache-dir appimage-builder
RUN apt install --no-install-recommends -y imagemagick-6.q16 gtk-update-icon-cache appstream && rm -rf /var/lib/apt/lists/*;
ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 14.17.0
RUN mkdir -p /usr/local/nvm
RUN curl -f -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash \
    && . $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default
RUN . $NVM_DIR/nvm.sh && npm install -g appcenter-cli && npm cache clean --force;
RUN apt install --no-install-recommends -y zip && rm -rf /var/lib/apt/lists/*;

RUN mkdir /project
RUN mkdir -p /home/coder/dconf
RUN chmod a+rwx /home/coder/dconf
WORKDIR /project
