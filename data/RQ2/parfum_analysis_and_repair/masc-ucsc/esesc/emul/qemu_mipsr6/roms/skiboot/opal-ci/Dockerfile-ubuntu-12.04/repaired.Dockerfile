FROM ubuntu:trusty
RUN sudo apt-get update -qq
RUN sudo apt-get install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN sudo add-apt-repository -y ppa:ubuntu-toolchain-r/test
RUN sudo apt-get update -qq
RUN sudo apt-get install --no-install-recommends -y gcc-4.8 libstdc++6 valgrind expect expect xterm ccache device-tree-compiler libssl-dev expect && rm -rf /var/lib/apt/lists/*;
RUN sudo apt-get install --no-install-recommends -y gcc-arm-linux-gnueabi gcc-powerpc64le-linux-gnu gcc && rm -rf /var/lib/apt/lists/*;
RUN sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.8 50
RUN sudo apt-get install --no-install-recommends -y wget curl && rm -rf /var/lib/apt/lists/*;
RUN curl -f -O https://www.kernel.org/pub/tools/crosstool/files/bin/x86_64/4.8.0/x86_64-gcc-4.8.0-nolibc_powerpc64-linux.tar.xz
RUN sudo mkdir /opt/cross
RUN sudo tar -C /opt/cross -xf x86_64-gcc-4.8.0-nolibc_powerpc64-linux.tar.xz && rm x86_64-gcc-4.8.0-nolibc_powerpc64-linux.tar.xz
RUN curl -f -O ftp://public.dhe.ibm.com/software/server/powerfuncsim/p8/packages/v1.0-2/systemsim-p8_1.0-2_amd64.deb
RUN sudo dpkg -i systemsim-p8_1.0-2_amd64.deb
RUN apt-get install --no-install-recommends -y libtcl8.6 && rm -rf /var/lib/apt/lists/*;
RUN curl -f -O http://public.dhe.ibm.com/software/server/powerfuncsim/p9/packages/v1.0-0/systemsim-p9-1.0-0-trusty_amd64.deb
RUN sudo dpkg -i systemsim-p9-1.0-0-trusty_amd64.deb
RUN sudo apt-get -y --no-install-recommends install eatmydata && rm -rf /var/lib/apt/lists/*;
RUN sudo eatmydata apt-get -y install build-essential gcc python g++ pkg-config libz-dev libglib2.0-dev libpixman-1-dev libfdt-dev git libstdc++6
COPY . /build/
WORKDIR /build
ENTRYPOINT ./opal-ci/build-ubuntu-12.04.sh
