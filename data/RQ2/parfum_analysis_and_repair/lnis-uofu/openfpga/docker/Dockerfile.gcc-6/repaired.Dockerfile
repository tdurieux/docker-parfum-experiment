FROM ghcr.io/lnis-uofu/openfpga-build-base
RUN apt-get update && apt-get install --no-install-recommends -y gcc-6 g++-6 && rm -rf /var/lib/apt/lists/*;
