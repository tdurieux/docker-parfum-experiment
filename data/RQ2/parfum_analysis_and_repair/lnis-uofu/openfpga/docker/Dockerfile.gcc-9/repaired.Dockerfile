FROM ghcr.io/lnis-uofu/openfpga-build-base
RUN apt-get install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:ubuntu-toolchain-r/test
RUN apt-get update && apt-get install --no-install-recommends -y gcc-9 g++-9 && rm -rf /var/lib/apt/lists/*;
