FROM fedora:latest

RUN dnf update -y

# Base Haiku requirements
RUN dnf install -y git nasm texinfo flex bison wget uboot-tools \
	gcc gcc-c++ make zlib-devel xorriso curl-devel byacc libtool \
	byacc libstdc++-static mtools python36 libfdt bc patch unzip \
	autoconf automake gettext-devel \
	libstdc++-devel.x86_64 libstdc++-devel.i686 \
	glibc-headers glibc-devel.x86_64 glibc-devel.i686

# GCC requirements
RUN dnf install -y python3
# zlib requirements
RUN dnf install -y cmake
# ICU requirements
RUN dnf install -y pkg-config
# texinfo requirements
RUN dnf install -y ncurses-devel

# Developer sundries (that won't impact bootstrap)
RUN dnf install -y vim nano
RUN echo "source /usr/share/vim/vim80/defaults.vim" > ~/.vimrc
RUN echo "set mouse=" >> ~/.vimrc

ENV GIT_BUILDTOOLS="https://review.haiku-os.org/buildtools"
ENV GIT_HAIKU="https://review.haiku-os.org/haiku"
ENV GIT_HAIKUPORTER="https://github.com/haikuports/haikuporter.git"
ENV GIT_HAIKUPORTS="https://github.com/haikuports/haikuports.git"
ENV GIT_HAIKUPORTS_CROSS="https://github.com/haikuports/haikuports.cross.git"

ADD prep.sh /usr/local/bin/prep
ADD crosstools.sh /usr/local/bin/crosstools
ADD bootstrap.sh /usr/local/bin/bootstrap
ADD haikuports_chroot.sh /usr/local/bin/haikuports_chroot
ADD haikuports_build.sh /usr/local/bin/haikuports_build

ENV WORKPATH="/work"
ENV PATH="$PATH:$WORKPATH/bin"

WORKDIR "/work"
VOLUME ["/work"]

ENTRYPOINT ["/bin/bash", "-c"]