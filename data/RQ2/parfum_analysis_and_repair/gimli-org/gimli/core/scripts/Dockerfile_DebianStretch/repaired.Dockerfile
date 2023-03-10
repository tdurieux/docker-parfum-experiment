# Dockerfile used to create a build environment for PyGimli based on the
# official Debian stretch base image

# before proceeding, copy to an empty directory and rename to "Dockerfile"

# build with:
# docker build -t "gimli/gimli_0.1" .

# after building, start an interactive console in the container with
# docker run --rm -i -t -u gimli -v "${PWD}":/HOST -w /home/gimli "gimli/gimli_0.1" bash
# note that this command will mount the present directory to /HOST in the
# container, e.g., to copy the final build to the host computer

# the start the build process with
# bash build_pygimli_py3.5.sh

FROM debian:stretch

RUN apt-get update

RUN apt-get install --no-install-recommends -y wget subversion git cmake mercurial && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libboost-all-dev libblas-dev liblapack-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python python-setuptools && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-numpy python-matplotlib && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libedit-dev clang llvm-dev python3-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3 python3-numpy python3-matplotlib && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3-setuptools && rm -rf /var/lib/apt/lists/*;

# not required, but used for debugging and testing
RUN apt-get install --no-install-recommends -y vim-nox python-pytest python3-pytest && rm -rf /var/lib/apt/lists/*;

USER root
# set the root password to "root"
RUN sh -c "echo root:root |chpasswd"

RUN useradd gimli | chpasswd gimli
RUN mkdir /home/gimli
RUN chmod -R 0777 /home/gimli
RUN chown -R gimli:gimli /home/gimli

USER gimli
ENV HOME "/home/gimli"

# COPY build_pygimli_py3.5.sh /home/gimli/build_pygimli_py3.5.sh
RUN echo '#!/bin/bash \n \
git clone https://github.com/gimli-org/gimli.git \n \
mkdir build \n \
cd build \n \
cmake ../gimli -DPYVERSION=3.5 \n \
make -j 2 gimli \n \
make -j 2 apps \n \
make -j 2 pygimli \n ' > /home/gimli/build_pygimli_py3.5.sh
