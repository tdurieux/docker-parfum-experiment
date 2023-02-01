FROM ubuntu:20.04
MAINTAINER Marco Poletti <poletti.marco@gmail.com>

COPY common_install.sh common_cleanup.sh /

RUN bash -x /common_install.sh

COPY ubuntu-20.04_custom.list /etc/apt/sources.list.d/

RUN apt-get update && apt-get install -y --allow-unauthenticated --no-install-recommends \
        g++-7 \
        g++-8 \
        g++-9 \
        g++-10 \
        clang-6.0 \
        clang-7 \
        clang-8 \
        clang-9 \
        clang-10 \
        python3.8 \
        python3.8-distutils \
        clang-tidy \
        clang-format && rm -rf /var/lib/apt/lists/*;
RUN apt-get remove -y python3-pip
RUN python3 -m easy_install pip
















RUN python3.8 -m easy_install pip

RUN pip3 install --no-cache-dir absl-py
RUN pip3 install --no-cache-dir bidict
RUN pip3 install --no-cache-dir pytest
RUN pip3 install --no-cache-dir pytest-xdist
RUN pip3 install --no-cache-dir sh
RUN pip3 install --no-cache-dir setuptools
RUN pip3 install --no-cache-dir networkx
RUN pip3 install --no-cache-dir wheel

RUN bash -x /common_cleanup.sh
