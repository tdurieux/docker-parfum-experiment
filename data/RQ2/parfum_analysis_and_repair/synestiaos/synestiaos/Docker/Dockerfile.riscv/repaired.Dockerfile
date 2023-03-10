FROM ubuntu:20.04

COPY sources.list /etc/apt/sources.list
COPY sshd_config /etc/ssh/sshd_config

WORKDIR /root/SynestiaOS

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install --no-install-recommends --fix-missing -y build-essential binutils qemu-system-arm \
       gdb-multiarch gcc-arm-none-eabi gcc-aarch64-linux-gnu make cmake gcc \
       gcc-riscv64-linux-gnu \
       clang-format-10 ssh rsync cmake-curses-gui less \
    && update-alternatives --install /usr/bin/clang-format clang-format /usr/bin/clang-format-10 100 \
    && apt-get clean \
    && apt-get autoremove \
    && rm -rf /var/cache/apt/archives \
    && mkdir /run/sshd \
    && yes password | passwd root \
    && echo 'set completion-ignore-case On' >> ~/.inputrc && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends --fix-missing -y \
					autoconf automake autotools-dev curl libmpc-dev libmpfr-dev libgmp-dev gawk bison flex texinfo gperf libtool patchutils bc zlib1g-dev libexpat-dev && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends --fix-missing -y git \
					&& git clone --depth=1 --recursive https://github.com/kendryte/kendryte-gnu-toolchain /root/kendryte/kendryte-gnu-toolchain && rm -rf /var/lib/apt/lists/*;
RUN cd /root/kendryte/kendryte-gnu-toolchain \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/opt/kendryte-toolchain --with-cmodel=medany --with-arch=rv64imafc --with-abi=lp64f \
    && make -j8

ENV PATH=$PATH:/opt/kendryte-toolchain/bin
ENV CC=/opt/kendryte-toolchain/bin/riscv64-unknown-elf-gcc
ENV CXX=/opt/kendryte-toolchain/bin/riscv64-unknown-elf-g++
ENV AS=/opt/kendryte-toolchain/bin/riscv64-unknown-elf-as
ENV AR=/opt/kendryte-toolchain/bin/riscv64-unknown-elf-ar

CMD ["/usr/sbin/sshd", "-D"]
