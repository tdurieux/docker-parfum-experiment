FROM centos:7.9.2009
ARG MAKE_OPTS=-j12
ARG SDL_VERSION

RUN yum groupinstall -y "Development Tools" && \
    yum install -y alsa-lib-devel dbus-devel fuse-devel libX11-devel \
                libXcursor-devel libXrandr-devel libXScrnSaver-devel \
                libXinerama-devel libXi-devel mesa-libEGL-devel \
                mesa-libGL-devel mkisofs pulseaudio-libs-devel sudo unzip && rm -rf /var/cache/yum

COPY vendor/SDL2-${SDL_VERSION}.tar.gz /tmp/
RUN cd /tmp && \
    tar xzf SDL2-${SDL_VERSION}.tar.gz && \
    cd SDL2-${SDL_VERSION} && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && \
    make ${MAKE_OPTS} && \
    make install && \
    echo "/usr/local/share/aclocal" > /usr/share/aclocal/dirlist && \
    rm -rf /tmp/SDL2-${SDL_VERSION}* && rm SDL2-${SDL_VERSION}.tar.gz
