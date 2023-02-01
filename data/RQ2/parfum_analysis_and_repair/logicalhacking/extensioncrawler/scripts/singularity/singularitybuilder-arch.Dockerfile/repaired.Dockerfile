FROM archlinux/base

ARG version=2.6.1

RUN curl -f -o /etc/pacman.d/mirrorlist "https://www.archlinux.org/mirrorlist/?country=GB&protocol=https&use_mirror_status=on" && \
    sed -i 's/^#//' /etc/pacman.d/mirrorlist && \
    pacman --noconfirm -Syyu base-devel wget python squashfs-tools debootstrap

RUN mkdir /tmp/singularity &&\
  cd /tmp/singularity &&\
  wget "https://github.com/singularityware/singularity/releases/download/${version}/singularity-${version}.tar.gz" &&\
  tar -xvzf singularity-${version}.tar.gz &&\
  cd singularity-${version} && \
  ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr/local && \
  make && \
  sudo make install && rm singularity-${version}.tar.gz
