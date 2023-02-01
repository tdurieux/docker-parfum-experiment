FROM ghcr.io/lnis-uofu/openfpga-build-base
RUN apt-get update && apt-get install --no-install-recommends -y clang-format-7 clang-6.0 && rm -rf /var/lib/apt/lists/*;
