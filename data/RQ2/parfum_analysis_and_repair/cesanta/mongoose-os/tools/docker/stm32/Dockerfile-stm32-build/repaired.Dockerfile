FROM ubuntu:bionic-20190807

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y -q --no-install-recommends \
      apt-utils autoconf automake bison build-essential curl flex gawk gdb-multiarch git gperf help2man \
      less libexpat-dev libncurses5-dev libtool-bin \
      python python-dev python-git python-pyelftools python-serial python-six python-yaml \
      python3 python3-dev python3-git python3-pyelftools python3-serial python3-six python3-yaml \
      software-properties-common texinfo unzip wget zip && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y -q --no-install-recommends \
      binutils-arm-none-eabi gcc-arm-none-eabi && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

# Install custom Newlib and libstdc++.
# Source packages are not necessary but it's good to have them embedded in the image, just in case.
RUN cd /opt && \
    wget -q https://mongoose-os.com/downloads/arm-libc/newlib/newlib_3.3.0-0ubuntu1~mos2.debian.tar.xz \
            https://mongoose-os.com/downloads/arm-libc/newlib/libnewlib-arm-none-eabi_3.3.0-0ubuntu1~mos2_all.deb \
            https://mongoose-os.com/downloads/arm-libc/newlib/libnewlib-dev_3.3.0-0ubuntu1~mos2_all.deb \
            https://mongoose-os.com/downloads/arm-libc/newlib/libnewlib-doc_3.3.0-0ubuntu1~mos2_all.deb \
            https://mongoose-os.com/downloads/arm-libc/libstdc++/libstdc++-arm-none-eabi_10~mos2.tar.xz \
            https://mongoose-os.com/downloads/arm-libc/libstdc++/libstdc++-arm-none-eabi-newlib_6.3.1+svn253039-1build1+10~mos2_all.deb && \
    dpkg -i *.deb && \
    rm *.deb

ARG STM32CUBE_F2_DIR
ADD tmp/$STM32CUBE_F2_DIR /opt/$STM32CUBE_F2_DIR
ENV STM32CUBE_F2_PATH /opt/$STM32CUBE_F2_DIR

ARG STM32CUBE_F4_DIR
ADD tmp/$STM32CUBE_F4_DIR /opt/$STM32CUBE_F4_DIR
ENV STM32CUBE_F4_PATH /opt/$STM32CUBE_F4_DIR

ARG STM32CUBE_L4_DIR
ADD tmp/$STM32CUBE_L4_DIR /opt/$STM32CUBE_L4_DIR
ENV STM32CUBE_L4_PATH /opt/$STM32CUBE_L4_DIR

ARG STM32CUBE_F7_DIR
ADD tmp/$STM32CUBE_F7_DIR /opt/$STM32CUBE_F7_DIR
ENV STM32CUBE_F7_PATH /opt/$STM32CUBE_F7_DIR

ARG TARGETARCH
ADD mgos_fw_meta.py $TARGETARCH/mklfs $TARGETARCH/mkspiffs $TARGETARCH/mkspiffs8 /usr/local/bin/
ADD serve_core/ /opt/serve_core/
RUN ln -s /opt/serve_core/serve_core.py /usr/local/bin/serve_core.py

ARG DOCKER_TAG
ENV MGOS_TARGET_GDB /usr/bin/gdb-multiarch
ENV MGOS_SDK_REVISION $DOCKER_TAG
ENV MGOS_SDK_BUILD_IMAGE docker.io/mgos/stm32-build:$DOCKER_TAG
