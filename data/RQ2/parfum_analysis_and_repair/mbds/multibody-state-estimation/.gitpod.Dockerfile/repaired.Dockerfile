FROM ubuntu:focal

# Install custom tools, runtimes, etc.
# For example "bastet", a command-line tetris clone:
# RUN brew install bastet
#
# More information: https://www.gitpod.io/docs/config-docker/

RUN apt-get update
RUN apt-get install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;

RUN add-apt-repository -y ppa:joseluisblancoc/mrpt
RUN add-apt-repository -y ppa:joseluisblancoc/gtsam-develop

RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y cmake build-essential libmrpt-dev libgtsam-dev && rm -rf /var/lib/apt/lists/*;

# gtsam deps:
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y libboost-all-dev && rm -rf /var/lib/apt/lists/*;

# git:
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y git && rm -rf /var/lib/apt/lists/*;

# clean packages cache
RUN rm -rf /var/lib/apt/lists/*

# Build:
COPY . /root/mbse-workspace/
WORKDIR /root/mbse-workspace/build/
RUN cmake .. -DCMAKE_INSTALL_PREFIX=/usr/
RUN make -j4
RUN make install
