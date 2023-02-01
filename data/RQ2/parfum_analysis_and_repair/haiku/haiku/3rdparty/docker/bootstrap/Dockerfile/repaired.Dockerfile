FROM docker.io/debian:bullseye-slim

ENV DEBIAN_FRONTEND="noninteractive"

RUN apt-get update

# Base Haiku requirements
RUN apt-get install --no-install-recommends -y git nasm autoconf automake autopoint texinfo \
	flex bison gawk build-essential unzip wget zip less zlib1g-dev \
	libzstd-dev libcurl4-openssl-dev genisoimage libtool \
	mtools gcc-multilib u-boot-tools util-linux device-tree-compiler bc && rm -rf /var/lib/apt/lists/*;

# GCC requirements
RUN apt-get install --no-install-recommends -y python3 && rm -rf /var/lib/apt/lists/*;
# zlib requirements
RUN apt-get install --no-install-recommends -y cmake && rm -rf /var/lib/apt/lists/*;
# ICU requirements
RUN apt-get install --no-install-recommends -y pkg-config && rm -rf /var/lib/apt/lists/*;
# texinfo requirements
RUN apt-get install --no-install-recommends -y libncurses-dev && rm -rf /var/lib/apt/lists/*;

# Developer sundries (that won't impact bootstrap)
RUN apt-get install --no-install-recommends -y vim nano && rm -rf /var/lib/apt/lists/*;
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
