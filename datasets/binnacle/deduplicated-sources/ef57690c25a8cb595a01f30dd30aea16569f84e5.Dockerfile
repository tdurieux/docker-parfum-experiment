# Muen Development Environment
#
# Build container:
#   docker build -t muen-dev-env -f Dockerfile.muen-dev-env .
#
# Enter the container:
#   docker run -it \
#     -v /tmp/.X11-unix:/tmp/.X11-unix \
#     -e DISPLAY=unix$DISPLAY muen-dev-env

# Base image
ARG distro_name=debian
ARG distro_version=stretch
FROM ${distro_name}:${distro_version}

LABEL maintainer "Adrian-Ken Rueegsegger <ken@codelabs.ch>"
LABEL description "This image provides the build environment for the Muen project"

ENV CC ccache gcc
ENV CXX ccache g++

# Install dependencies
RUN apt-get update && apt-get install -y \
		acpica-tools \
		amtterm \
		bc \
		binutils-dev \
		bison \
		bzip2 \
		ca-certificates \
		ccache \
		cpio \
		curl \
		file \
		flex \
		g++ \
		git-core \
		gnuplot \
		grub-pc-bin \
		inotify-tools \
		lcov \
		libc6-dev \
		libcurl4-gnutls-dev \
		libelf-dev \
		libiberty-dev \
		libncurses-dev \
		libsdl1.2-dev \
		libssl-dev \
		libxml2-utils \
		make \
		openssh-client \
		patch \
		python \
		rsync \
		tidy \
		unzip \
		vim \
		wget \
		xorriso \
		xsltproc \
		xz-utils \
		zlib1g-dev \
		--no-install-recommends \
		&& rm -rf /var/lib/apt/lists/*

# Install AdaCore toolchain
RUN git clone https://github.com/AdaCore/gnat_community_install_script.git /tmp/gnat_script \
	&& curl -sSL "https://www.codelabs.ch/download/ada/gnat-community-2019-20190517-x86_64-linux-bin" -o /tmp/gnat_installer.bin \
	&& sh /tmp/gnat_script/install_package.sh /tmp/gnat_installer.bin /opt/gnat \
	&& rm -rf /tmp/gnat*

# Install Bochs for emulation
ARG bochs_revison=89265f376
RUN git clone https://github.com/svn2github/bochs.git /tmp/bochs \
	&& cd /tmp/bochs/bochs \
	&& git checkout ${bochs_revison} \
	&& ./configure \
		--prefix=/usr/local \
		--enable-vmx=2 \
		--enable-smp \
		--enable-cdrom \
		--enable-x86-64 \
		--enable-avx \
		--with-sdl \
		--with-term \
	&& make install \
	&& rm -rf /tmp/bochs

# amtc tool
RUN git clone https://github.com/schnoddelbotz/amtc.git /tmp/amtc \
	&& cd /tmp/amtc \
	&& make amtc \
	&& cp src/amtc /usr/local/bin \
	&& rm -rf /tmp/amtc

# Setup environment
ENV HOME /home/user
ENV LANG C.UTF-8
ENV PATH /opt/gnat/bin:$PATH

# Add development user
RUN useradd --create-home --home-dir $HOME user -G dialout

WORKDIR $HOME
USER user

CMD [ "bash" ]
