FROM ubuntu:14.04
LABEL Description="Docker for nuttx"


RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -sf /bin/true /sbin/initctl
ENV DEBIAN_FRONTEND noninteractive

ENV DISTRIB_CODENAME trusty
ENV TOOLCHAIN_VERSION 4.9.3.2015q3-1trusty1

RUN echo "deb http://ppa.launchpad.net/terry.guo/gcc-arm-embedded/ubuntu $DISTRIB_CODENAME main" >> /etc/apt/sources.list
RUN echo "deb-src http://ppa.launchpad.net/terry.guo/gcc-arm-embedded/ubuntu $DISTRIB_CODENAME main" >> /etc/apt/sources.list


# install 32 bit libraries required for gnuarm tools from 
# https://launchpad.net/gcc-arm-embedded & a few minimalistic tools with ssh server
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get -y install \
    libc6:i386 libncurses5:i386 libstdc++6:i386 libpython2.7:i386 \
    make git \
    sudo curl less vim-tiny tree openssh-server

RUN apt-get install -y lrzsz zip
RUN apt-get install -y libxml2-dev pkg-config picocom screen libusb-1.0-0-dev autotools-dev autoconf gperf flex bison libncurses5-dev libtool zlib1g-dev build-essential
RUN apt-get install -y --force-yes gcc-arm-none-eabi=$TOOLCHAIN_VERSION 
RUN apt-get install -y  cmake  make  automake  python-setuptools  ninja-build  python-dev  libffi-dev  libssl-dev  software-properties-common python-software-properties
RUN apt-get -y upgrade

# clean cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/run/sshd
RUN useradd -G sudo --create-home --shell /bin/bash --user-group ros
RUN echo "ros:ros" | chpasswd

CMD ["/usr/sbin/sshd", "-D"]
EXPOSE 22

ENV ROS_WORKSPACE /home/ros/workspace
VOLUME ${ROS_WORKSPACE}

VOLUME /dev/bus/usb:/dev/bus/usb