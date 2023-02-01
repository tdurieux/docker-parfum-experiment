FROM debian:buster
LABEL Description="Image for bitbaking"

RUN sed -i 's#deb http://deb.debian.org/debian buster main#deb http://deb.debian.org/debian buster main contrib#g' /etc/apt/sources.list
RUN sed -i 's#deb http://deb.debian.org/debian buster-updates main#deb http://deb.debian.org/debian buster-updates main contrib#g' /etc/apt/sources.list
RUN apt-get update -q && apt-get install --no-install-suggests --no-install-recommends -qy \
     awscli \
     build-essential \
     bzip2 \
     chrpath \
     cpio \
     default-jre \
     diffstat \
     file \
     gawk \
     gcc-multilib \
     git-core \
     iputils-ping \
     iproute2 \
     libpython-dev \
     libpython3-dev \
     libsdl1.2-dev \
     libvirt-clients \
     libvirt-daemon-system \
     locales \
     ovmf \
     openssh-client \
     procps \
     python \
     python3 \
     python3-pexpect \
     qemu-kvm \
     socat \
     sudo \
     texinfo \
     unzip \
     wget \
     xterm \
     xz-utils && rm -rf /var/lib/apt/lists/*;

ARG uid=4321
ARG gid=4321
RUN groupadd -g $gid bitbake
RUN useradd -m -u $uid -g $gid -s /bin/bash bitbake

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && locale-gen
ENV LC_ALL="en_US.UTF-8"
ENV LANG="en_US.UTF-8"
ENV LANGUAGE="en_US.UTF-8"

# script to mirror kvm group id with host
RUN echo "bitbake ALL=NOPASSWD: /usr/local/bin/setup_kvm.sh" >> /etc/sudoers
COPY ./docker/setup_kvm.sh /usr/local/bin/setup_kvm.sh

# other ci scripts
RUN mkdir /scripts
COPY configure.sh build.sh oe-selftest.sh /scripts/

USER "bitbake"
