# Dockerfile for busybox using buildroot
FROM            radial/distro:us-west-1
MAINTAINER      Brian Clements <radial@brianclements.net>

# Install packages
ENV             DEBIAN_FRONTEND noninteractive
RUN apt-get -q update && apt-get -qyV --no-install-recommends install \
                    wget \
                    build-essential \
                    libncurses-dev \
                    rsync \
                    unzip \
                    bc \
                    gnupg \
                    python && rm -rf /var/lib/apt/lists/*;
RUN             env --unset=DEBIAN_FRONTEND

# Create directories
RUN             mkdir -p /tmp/builder
WORKDIR         /tmp/builder

# Retrieve files and check authenticity
ENV             BR_VERSION 2014.02
RUN wget -nv https://buildroot.uclibc.org/downloads/buildroot-$BR_VERSION.tar.gz && \
                wget -nv https://buildroot.uclibc.org/downloads/buildroot-$BR_VERSION.tar.gz.sign && \
                wget -nv https://uclibc.org/~jacmet/pubkey.gpg && \
                gpg --batch --import pubkey.gpg && \
                gpg --batch --verify buildroot-$BR_VERSION.tar.gz.sign

# Extract
RUN tar -zxf buildroot-$BR_VERSION.tar.gz && \
                mv buildroot-$BR_VERSION buildroot && rm buildroot-$BR_VERSION.tar.gz
WORKDIR         /tmp/builder/buildroot

# Configure base buildroot image
RUN             make defconfig

# Add base config
RUN             sed -i 's/BR2_i386=y/BR2_x86_64=y/' .config &&\
                echo BR2_TOOLCHAIN_BUILDROOT_LARGEFILE=y >>.config &&\
                echo BR2_TOOLCHAIN_BUILDROOT_INET_IPV6=y >>.config &&\
                echo BR2_TOOLCHAIN_BUILDROOT_WCHAR=y >>.config

# Reformat config and prep for make           
RUN             make oldconfig

# Make
RUN             make --quiet

# Done!
RUN             cp /tmp/builder/buildroot/output/images/rootfs.tar /tmp/rootfs.tar
WORKDIR         /tmp
RUN             md5sum rootfs.tar > rootfs.tar.md5
