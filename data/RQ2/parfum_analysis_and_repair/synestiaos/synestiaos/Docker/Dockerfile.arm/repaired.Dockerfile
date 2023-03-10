FROM ubuntu:20.04

COPY sources.list /etc/apt/sources.list
COPY sshd_config /etc/ssh/sshd_config

WORKDIR /root/SynestiaOS

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install --no-install-recommends --fix-missing -y build-essential binutils qemu-system-arm \
       gdb-multiarch gcc-arm-none-eabi gcc-aarch64-linux-gnu g++-aarch64-linux-gnu make cmake gcc \
       gcc-riscv64-linux-gnu \
       clang-format-10 ssh rsync cmake-curses-gui less \
    && update-alternatives --install /usr/bin/clang-format clang-format /usr/bin/clang-format-10 100 \
    && apt-get clean \
    && apt-get autoremove \
    && rm -rf /var/cache/apt/archives \
    && mkdir /run/sshd \
    && yes password | passwd root \
    && echo 'set completion-ignore-case On' >> ~/.inputrc && rm -rf /var/lib/apt/lists/*;

ENV CC=/usr/bin/arm-none-eabi-gcc
ENV CXX=/usr/bin/arm-none-eabi-g++
ENV AS=/usr/bin/arm-none-eabi-as
ENV AR=/usr/bin/arm-none-eabi-ar

CMD ["/usr/sbin/sshd", "-D"]
