FROM DISTRO
# Docker build arguments
ARG SOURCE_DIR=/ffmpeg
ARG ARTIFACT_DIR=/dist
# Docker run environment
ENV DEB_BUILD_OPTIONS=noddebs
ENV DEBIAN_FRONTEND=noninteractive
ENV ARCH=BUILD_ARCHITECTURE
ENV GCC_VER=GCC_RELEASE_VERSION
ENV SOURCE_DIR=/ffmpeg
ENV ARTIFACT_DIR=/dist
ENV TARGET_DIR=/usr/lib/jellyfin-ffmpeg
ENV DPKG_INSTALL_LIST=${SOURCE_DIR}/debian/jellyfin-ffmpeg5.install
ENV PATH=${TARGET_DIR}/bin:${PATH}
ENV PKG_CONFIG_PATH=${TARGET_DIR}/lib/pkgconfig:${PKG_CONFIG_PATH}
ENV LD_LIBRARY_PATH=${TARGET_DIR}/lib:${TARGET_DIR}/lib/mfx:${TARGET_DIR}/lib/xorg:${LD_LIBRARY_PATH}
ENV LDFLAGS="-Wl,-rpath=${TARGET_DIR}/lib -L${TARGET_DIR}/lib"
ENV CXXFLAGS="-I${TARGET_DIR}/include $CXXFLAGS"
ENV CPPFLAGS="-I${TARGET_DIR}/include $CPPFLAGS"
ENV CFLAGS="-I${TARGET_DIR}/include $CFLAGS"

# Prepare Debian build environment
RUN apt-get update \
 && yes | apt-get install --no-install-recommends -y apt-transport-https curl ninja-build debhelper gnupg wget devscripts mmv equivs git nasm pkg-config subversion dh-autoreconf libpciaccess-dev libwayland-dev libx11-dev libx11-xcb-dev libxcb-dri2-0-dev libxcb-dri3-dev libxcb-present-dev libxcb-shm0-dev libxcb-sync-dev libxshmfence-dev libxext-dev libxfixes-dev libxcb1-dev libxrandr-dev libzstd-dev libelf-dev libudev-dev python3-pip python3-mako zip unzip tar flex bison && rm -rf /var/lib/apt/lists/*;

# Install meson and cmake
RUN pip3 install --no-cache-dir meson cmake
# Avoids timeouts when using git and disable the detachedHead advice
RUN git config --global http.postbuffer 524288000 && git config --global advice.detachedHead false
# Link to docker-build script
RUN ln -sf ${SOURCE_DIR}/docker-build.sh /docker-build.sh

VOLUME ${ARTIFACT_DIR}/

COPY . ${SOURCE_DIR}/

ENTRYPOINT ["/docker-build.sh"]
