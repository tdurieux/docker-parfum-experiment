FROM ubuntu:latest

ENV TZ=Europe/Warsaw
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && \
  apt-get install --no-install-recommends -y \
    git \
    jq \
    mercurial \
    python3 \
    python3-pip \
    wget \
    sudo && rm -rf /var/lib/apt/lists/*;
RUN apt-get clean

RUN cd /opt && \
  wget https://developer.arm.com/-/media/Files/downloads/gnu-rm/10.3-2021.10/gcc-arm-none-eabi-10.3-2021.10-x86_64-linux.tar.bz2 && \
  tar xvf gcc-arm-none-eabi-10.3-2021.10-x86_64-linux.tar.bz2 && \
  ln -s gcc-arm-none-eabi-10.3-2021.10 gcc-arm-none-eabi && \
  rm gcc-arm-none-eabi-10.3-2021.10-x86_64-linux.tar.bz2

RUN pip install --no-cache-dir mbed-cli

# create mbed-os cache (root user)
RUN mbed new /tmp/mbed && \
  pip install --no-cache-dir -r /tmp/mbed/mbed-os/requirements.txt && \
  rm -rf /tmp/mbed

RUN mbed config -G TOOLCHAIN GCC_ARM && \
  mbed config -G GCC_ARM_PATH /opt/gcc-arm-none-eabi/bin
