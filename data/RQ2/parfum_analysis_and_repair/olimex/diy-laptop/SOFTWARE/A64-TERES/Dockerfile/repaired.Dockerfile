FROM ubuntu:xenial

RUN apt-get update
RUN apt-get install --no-install-recommends -y git-core build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y g++-4.9-aarch64-linux-gnu gcc-4.9-aarch64-linux-gnu \
  g++-4.7-arm-linux-gnueabihf gcc-4.7-arm-linux-gnueabihf && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y device-tree-compiler && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y dos2unix && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y ccache gcc-aarch64-linux-gnu && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y u-boot-tools && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y kpartx bsdtar mtools bc cpio && rm -rf /var/lib/apt/lists/*;

RUN cd /usr/bin/ && \
  ln -s arm-linux-gnueabihf-gcc-4.7 arm-linux-gnueabihf-gcc && \
  ln -s arm-linux-gnueabihf-g++-4.7 arm-linux-gnueabihf-g++ && \
  ln -s arm-linux-gnueabihf-cpp-4.7 arm-linux-gnueabihf-cpp

