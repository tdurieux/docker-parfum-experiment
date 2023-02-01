FROM ubuntu:bionic

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

CMD ["sh"]

ENV DEBIAN_FRONTEND=noninteractive
ENV CCACHE_DIR=/var/spool/ccache
ENV CCACHE_COMPRESS=1

# We use clang to build as Spicy requires a C++17-capable compiler. Bionic
# ships with gcc-8.4.0, but we require at least gcc-9 which is only available
# in testing here. Use an LLVM stack instead.
ENV CXX=clang++-9
ENV CC=clang-9

RUN apt-get update \
 && apt-get install -y --no-install-recommends curl ca-certificates gnupg2 \
 # Spicy build and test dependencies.
 && apt-get install -y --no-install-recommends git ninja-build ccache g++ llvm-9-dev clang-9 libclang-9-dev flex libfl-dev python3 python3-pip zlib1g-dev libssl-dev jq locales-all python3-setuptools python3-wheel make bison \
 && pip3 install --no-cache-dir "btest>=0.66" pre-commit \
 # Spicy doc dependencies.
 && apt-get install -y --no-install-recommends python3 python3-pip python3-sphinx python3-sphinx-rtd-theme python3-setuptools python3-wheel doxygen \
 && pip3 install --no-cache-dir "btest>=0.66" pre-commit \
 # Cleanup.
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# Install a recent CMake.
WORKDIR /usr/local/cmake
RUN curl -f -L https://github.com/Kitware/CMake/releases/download/v3.18.0/cmake-3.18.0-Linux-x86_64.tar.gz | tar xzvf - -C /usr/local/cmake --strip-components 1
ENV PATH="/usr/local/cmake/bin:${PATH}"

WORKDIR /root
