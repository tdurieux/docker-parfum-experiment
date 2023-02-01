ARG OS=fedora:29
FROM ${OS}

SHELL ["bash", "-euxvc"]

RUN dnf install -y rpm-build dnf-utils rpmdevtools; \
    dnf clean all

# Bootstrap
RUN dnf install -y bison cairo-devel clang cmake dkms flex fontconfig-devel.x86_64 \
                   fontconfig-devel.i686 freetype-devel.x86_64 freetype-devel.i686 \
                   fuse-devel glibc-devel glibc-devel.i686 kernel-devel \
                   libglvnd-devel libjpeg-turbo-devel libjpeg-turbo-devel.i686 \
                   libtiff-devel libtiff-devel.i686 mesa-libGL-devel mesa-libEGL-devel \
                   python2 systemd-devel make libxml2-devel elfutils-libelf-devel \
                   libbsd-devel; \
    dnf clean all

RUN mkdir -p /root/rpmbuild/SOURCES

CMD bash -xv /src/rpm/build.bsh
