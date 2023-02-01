FROM ubuntu:focal

# Increase this to force a rebuild of the Docker image (in Cirrus, in particular).
ENV IMAGE_VERSION=1

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

CMD ["sh"]
ENV DEBIAN_FRONTEND=noninteractive
ENV PATH="/opt/spicy/bin:${PATH}"

RUN apt-get update \
 && apt-get install -y --no-install-recommends curl ca-certificates gnupg2 less sudo \
 # Spicy build and test dependencies.
 && apt-get install -y --no-install-recommends git cmake ninja-build ccache bison flex g++ libfl-dev zlib1g-dev libssl-dev jq locales-all make \
 # Spicy doc dependencies.
 && apt-get install -y --no-install-recommends python3 python3-pip python3-sphinx python3-sphinx-rtd-theme python3-setuptools python3-wheel doxygen \
 && pip3 install --no-cache-dir "btest>=0.66" pre-commit \
 # Install a recent CMake.
 && mkdir -p /opt/cmake \
 && curl -f -L https://github.com/Kitware/CMake/releases/download/v3.18.0/cmake-3.18.0-Linux-x86_64.tar.gz | tar xzvf - -C /opt/cmake --strip-components 1 \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

ENV PATH="/opt/cmake/bin:${PATH}"

WORKDIR /root
