FROM bernddoser/docker-devel-cpp:ubuntu-16.04-cmake-3.10

LABEL maintainer="Bernd Doser <bernd.doser@braintwister.eu>"

RUN apt-add-repository -y ppa:ubuntu-toolchain-r/test \
 && apt-get update \
 && apt-get install --no-install-recommends -y \
    gcc-6 \
    g++-6 \
    gdb \
 && apt-get clean \
 && ln -sf /usr/bin/g++-6 /usr/bin/g++ \
 && ln -sf /usr/bin/gcc-6 /usr/bin/gcc && rm -rf /var/lib/apt/lists/*;

ENV CC gcc
ENV CXX g++
