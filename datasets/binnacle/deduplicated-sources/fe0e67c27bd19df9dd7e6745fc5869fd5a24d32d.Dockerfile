FROM debian:testing

ENV DEBIAN_FRONTEND=noninteractive

RUN echo 'path-exclude=/usr/share/doc/*' > /etc/dpkg/dpkg.cfg.d/99-exclude-cruft
RUN echo 'path-exclude=/usr/share/man/*' >> /etc/dpkg/dpkg.cfg.d/99-exclude-cruft
RUN echo '#!/bin/sh' > /usr/sbin/policy-rc.d
RUN echo 'exit 101' >> /usr/sbin/policy-rc.d
RUN chmod +x /usr/sbin/policy-rc.d

############### Install packages for building

ARG DEBIAN_ARCH
RUN dpkg --add-architecture ${DEBIAN_ARCH}
RUN echo deb-src http://deb.debian.org/debian testing main >> /etc/apt/sources.list
RUN apt-get update && \
    apt-get -y install ca-certificates && \
    apt-get -y install --no-install-recommends \
      crossbuild-essential-${DEBIAN_ARCH} \
      meson \
      g++ \
      git \
      ccache \
      pkg-config \
      python3-mako \
      python-numpy \
      python-six \
      python-mako \
      python3-pip \
      python3-setuptools \
      python3-six \
      python3-wheel \
      python3-jinja2 \
      bison \
      flex \
      libwayland-dev \
      gettext \
      cmake \
      bc \
      libssl-dev \
      lavacli \
      csvkit \
      curl \
      unzip \
      wget \
      debootstrap \
      procps \
      qemu-user-static \
      cpio \
      \
      libdrm-dev:${DEBIAN_ARCH} \
      libx11-dev:${DEBIAN_ARCH} \
      libxxf86vm-dev:${DEBIAN_ARCH} \
      libexpat1-dev:${DEBIAN_ARCH} \
      libsensors-dev:${DEBIAN_ARCH} \
      libxfixes-dev:${DEBIAN_ARCH} \
      libxdamage-dev:${DEBIAN_ARCH} \
      libxext-dev:${DEBIAN_ARCH} \
      x11proto-dev:${DEBIAN_ARCH} \
      libx11-xcb-dev:${DEBIAN_ARCH} \
      libxcb-dri2-0-dev:${DEBIAN_ARCH} \
      libxcb-glx0-dev:${DEBIAN_ARCH} \
      libxcb-xfixes0-dev:${DEBIAN_ARCH} \
      libxcb-dri3-dev:${DEBIAN_ARCH} \
      libxcb-present-dev:${DEBIAN_ARCH} \
      libxcb-randr0-dev:${DEBIAN_ARCH} \
      libxcb-sync-dev:${DEBIAN_ARCH} \
      libxrandr-dev:${DEBIAN_ARCH} \
      libxshmfence-dev:${DEBIAN_ARCH} \
      libelf-dev:${DEBIAN_ARCH} \
      libwayland-dev:${DEBIAN_ARCH} \
      libwayland-egl-backend-dev:${DEBIAN_ARCH} \
      libclang-7-dev:${DEBIAN_ARCH} \
      zlib1g-dev:${DEBIAN_ARCH} \
      libglvnd-core-dev:${DEBIAN_ARCH} \
      wayland-protocols:${DEBIAN_ARCH} \
      libpng-dev:${DEBIAN_ARCH} && \
    rm -rf /var/lib/apt/lists

############### Cross-build dEQP
ARG GCC_ARCH
RUN mkdir -p /artifacts/rootfs/deqp                                             && \
  wget https://github.com/KhronosGroup/VK-GL-CTS/archive/opengl-es-cts-3.2.5.0.zip && \
  unzip -q opengl-es-cts-3.2.5.0.zip -d /                                       && \
  rm opengl-es-cts-3.2.5.0.zip                                                  && \
  cd /VK-GL-CTS-opengl-es-cts-3.2.5.0                                           && \
  python3 external/fetch_sources.py                                             && \
  cd /artifacts/rootfs/deqp                                                     && \
  cmake -DDEQP_TARGET=wayland                                                      \
    -DCMAKE_BUILD_TYPE=Release                                                     \
    -DCMAKE_C_COMPILER=${GCC_ARCH}-gcc                                             \
    -DCMAKE_CXX_COMPILER=${GCC_ARCH}-g++                                           \
    /VK-GL-CTS-opengl-es-cts-3.2.5.0                                            && \
  make -j$(nproc)                                                               && \
  rm -rf /artifacts/rootfs/deqp/external                                        && \
  rm -rf /artifacts/rootfs/deqp/modules/gles3                                   && \
  rm -rf /artifacts/rootfs/deqp/modules/gles31                                  && \
  rm -rf /artifacts/rootfs/deqp/modules/internal                                && \
  rm -rf /artifacts/rootfs/deqp/executor                                        && \
  rm -rf /artifacts/rootfs/deqp/execserver                                      && \
  rm -rf /artifacts/rootfs/deqp/modules/egl                                     && \
  rm -rf /artifacts/rootfs/deqp/framework                                       && \
  find . -name CMakeFiles | xargs rm -rf                                        && \
  find . -name lib\*.a | xargs rm -rf                                           && \
  du -sh *                                                                      && \
  rm -rf /VK-GL-CTS-opengl-es-cts-3.2.5.0


############### Cross-build kernel

ARG KERNEL_ARCH
ARG DEFCONFIG
ARG DEVICE_TREES
ARG KERNEL_IMAGE_NAME
ENV KERNEL_URL="https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux/+archive/refs/tags/v5.2-rc2.tar.gz"

COPY ${KERNEL_ARCH}.config /panfrost-ci/
RUN mkdir -p /kernel                                                                   && \
  wget -qO- ${KERNEL_URL} | tar -xvz -C /kernel                                        && \
  cd /kernel                                                                           && \
  ARCH=${KERNEL_ARCH} CROSS_COMPILE="${GCC_ARCH}-" ./scripts/kconfig/merge_config.sh ${DEFCONFIG} /panfrost-ci/${KERNEL_ARCH}.config && \
  ARCH=${KERNEL_ARCH} CROSS_COMPILE="${GCC_ARCH}-" make -j12 ${KERNEL_IMAGE_NAME} dtbs && \
  cp arch/${KERNEL_ARCH}/boot/${KERNEL_IMAGE_NAME} /artifacts/.                        && \
  cp ${DEVICE_TREES} /artifacts/.                                                      && \
  rm -rf /kernel


############### Create rootfs

COPY create-rootfs.sh /artifacts/rootfs/
RUN debootstrap --variant=minbase --arch=${DEBIAN_ARCH} testing /artifacts/rootfs/ http://deb.debian.org/debian && \
    chroot /artifacts/rootfs sh /create-rootfs.sh                                                               && \
    rm /artifacts/rootfs/create-rootfs.sh

ENTRYPOINT [""]
