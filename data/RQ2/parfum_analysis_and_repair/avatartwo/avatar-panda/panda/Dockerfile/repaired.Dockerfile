FROM ubuntu:14.04
RUN echo "deb http://archive.ubuntu.com/ubuntu/ trusty universe multiverse" >> \
    /etc/apt/sources.list
RUN echo "deb-src http://archive.ubuntu.com/ubuntu/ trusty universe multiverse" >> \
    /etc/apt/sources.list
RUN sed -i "s/# deb-src /deb-src /g" /etc/apt/sources.list
RUN apt-get update && apt-get -y --no-install-recommends install $PACKAGES && rm -rf /var/lib/apt/lists/*; ENV PACKAGES flex bison \
    libusb-1.0-0-dev libiscsi-dev librados-dev libncurses5-dev \
    libseccomp-dev libgnutls-dev libssh2-1-dev  libspice-server-dev \
    libspice-protocol-dev libnss3-dev libfdt-dev \
    libgtk-3-dev libvte-2.90-dev libsdl1.2-dev libpng12-dev libpixman-1-dev \
    git make ccache python-yaml gcc clang sparse

RUN dpkg -l $PACKAGES | sort > /packages.txt
ENV FEATURES clang pyyaml

RUN git clone https://github.com/panda-re/panda
RUN cd panda && ./panda/scripts/install_ubuntu.sh

ENV PATH="/panda/build/x86_64-softmmu/:${PATH}"
