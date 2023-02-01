# ARM GCC toolchain

FROM ndless/gcc

# make sure the package repository is up to date
RUN apt-get update && apt-get install --no-install-recommends -y libgmp-dev libmpfr-dev libmpc-dev zlib1g-dev libtinfo-dev python2.7-dev libboost-program-options-dev xz-utils && rm -rf /var/lib/apt/lists/*; # install the dependencies


RUN useradd -m -d /home/ndless -p ndless ndless && chsh -s /bin/bash ndless

ADD . /ndless-sdk

# build the toolchain, cleanup and set up the PATH
RUN chown -R ndless:ndless /ndless-sdk && cd /ndless-sdk/toolchain && su ndless -c "./build_toolchain.sh && rm -rf download build-binutils build binutils-* gcc-* gdb-* newlib-* "

ENV PATH /ndless-sdk/toolchain/install/bin:$PATH

