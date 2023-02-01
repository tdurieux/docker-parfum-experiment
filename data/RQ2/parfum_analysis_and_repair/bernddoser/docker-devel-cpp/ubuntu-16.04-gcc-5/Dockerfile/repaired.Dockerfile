FROM bernddoser/docker-devel-cpp:ubuntu-16.04

LABEL maintainer="Bernd Doser <bernd.doser@braintwister.eu>"

RUN apt-add-repository -y ppa:ubuntu-toolchain-r/test \
 && apt-get update \
 && apt-get install --no-install-recommends -y gcc-5 g++-5 \
 && apt-get clean \
 && ln -sf /usr/bin/g++-5 /usr/bin/g++ \
 && ln -sf /usr/bin/gcc-5 /usr/bin/gcc && rm -rf /var/lib/apt/lists/*;

ENV CC gcc
ENV CXX g++
