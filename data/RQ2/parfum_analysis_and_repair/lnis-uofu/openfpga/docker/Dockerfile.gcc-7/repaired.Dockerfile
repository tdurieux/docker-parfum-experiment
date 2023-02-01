FROM ghcr.io/lnis-uofu/openfpga-build-base
RUN apt-get update && apt-get install --no-install-recommends -y gcc-7 g++-7 && rm -rf /var/lib/apt/lists/*;
