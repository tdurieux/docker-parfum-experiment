FROM ubuntu:17.04

MAINTAINER Edgar Riba <edgar.riba@gmail.com>

# install basic stuff

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential       \
    cmake                 \
    python-pip            \
    python-setuptools     \
    git                   \
    vim && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir --upgrade pip

# install optional dependencies

RUN apt-get install --no-install-recommends -y \
    libpthread-stubs0-dev \
    libtbb-dev && rm -rf /var/lib/apt/lists/*;

# install linters

RUN apt-get install --no-install-recommends -y \
    clang-format-4.0 && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir cpplint
