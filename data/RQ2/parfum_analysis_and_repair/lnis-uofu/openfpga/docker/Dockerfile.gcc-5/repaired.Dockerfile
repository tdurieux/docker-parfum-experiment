FROM ghcr.io/lnis-uofu/openfpga-build-base
RUN apt-get update && apt-get install --no-install-recommends -y gcc-5 g++-5 && rm -rf /var/lib/apt/lists/*;
