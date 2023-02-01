FROM bernddoser/docker-devel-cpp:ubuntu-17.04

LABEL maintainer="Bernd Doser <bernd.doser@braintwister.eu>"

RUN apt-add-repository -y ppa:ubuntu-toolchain-r/test \
 && apt-get update \
 && apt-get install --no-install-recommends -y gcc-7 g++-7 \
 && apt-get clean \
 && ln -sf /usr/bin/g++-7 /usr/bin/g++ \
 && ln -sf /usr/bin/gcc-7 /usr/bin/gcc && rm -rf /var/lib/apt/lists/*;

ENV CC gcc
ENV CXX g++
