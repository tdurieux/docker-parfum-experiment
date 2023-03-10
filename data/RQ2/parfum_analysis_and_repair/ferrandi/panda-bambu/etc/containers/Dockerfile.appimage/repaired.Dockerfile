ARG BASE=ubuntu:xenial
FROM ${BASE}
ARG DEBIAN_FRONTEND=noninteractive

ENV TZ=Europe/Rome
WORKDIR /tmp
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
   && apt-get update && apt-get install -y --no-install-recommends \
   autoconf autoconf-archive automake bison bzip2 ca-certificates ccache cmake curl \
   doxygen flex git graphviz lsb-release make pkg-config rsync \
   texlive-latex-recommended texlive-latex-extra time wget xz-utils \
   g++ gcc gcc-multilib g++-multilib libc6-dev-i386 linux-libc-dev zlib1g-dev \
   libbdd-dev libfl-dev libglpk-dev libicu-dev libltdl-dev liblzma-dev libmpc-dev \
   libmpfi-dev libmpfr-dev libsuitesparse-dev libtool libxml2-dev \
   locales \
   && rm -rf /var/lib/apt/lists/* \
   && update-ca-certificates \
   && locale-gen en_US.UTF-8 \
   # Install AppImage tools
   && wget "https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage" \
   && chmod +x /tmp/appimagetool-x86_64.AppImage \
   && cd /opt && /tmp/appimagetool-x86_64.AppImage --appimage-extract \
   && mv squashfs-root appimage-tool.AppDir \
   && ln -s /opt/appimage-tool.AppDir/AppRun /usr/bin/appimagetool \
   && rm /tmp/appimagetool-x86_64.AppImage \
   # Install patch for appimage tool inside docker
   && wget https://github.com/NixOS/patchelf/releases/download/0.12/patchelf-0.12.tar.bz2 \
   && tar -xf patchelf-0.12.tar.bz2  \
   && cd patchelf-0.12.20200827.8d3a16e \
   && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && make install \
   && rm -rf patchelf-* \
   # Built and install boost libraries
   && git clone --depth 1 --branch boost-1.76.0 --recurse-submodules https://github.com/boostorg/boost.git \
   && cd boost \
   && ./bootstrap.sh --with-libraries=date_time,filesystem,graph,headers,iostreams,program_options,regex,system,wave --prefix=/usr \
   && ./b2 release install \
   && cd .. && rm -r boost && rm patchelf-0.12.tar.bz2

WORKDIR /
CMD [ "/bin/bash" ]
