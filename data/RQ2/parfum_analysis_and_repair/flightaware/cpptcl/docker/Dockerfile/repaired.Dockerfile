from travisci/ci-garnet:packer-1490989530

RUN add-apt-repository -y ppa:ubuntu-toolchain-r/test
RUN apt-get update -qq
RUN apt-get install --no-install-recommends -y gcc-7 g++-7 && rm -rf /var/lib/apt/lists/*;
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-7 70 --slave /usr/bin/g++ g++ /usr/bin/g++-7
RUN apt-get install --no-install-recommends -y tcl8.6-dev && rm -rf /var/lib/apt/lists/*;
