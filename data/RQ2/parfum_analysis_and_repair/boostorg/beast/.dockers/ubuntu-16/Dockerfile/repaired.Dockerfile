FROM ubuntu:16.04

RUN apt-get update
RUN apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y git cmake libssl-dev clang libc++-dev libc++abi-dev libbz2-dev zlib1g-dev && rm -rf /var/lib/apt/lists/*;

WORKDIR /devel
RUN git clone -b develop https://github.com/boostorg/boost.git
COPY .dockers/ubuntu-16/user-config.jam /devel/boost/
COPY .dockers/ubuntu-16/tests.sh /devel/boost/

WORKDIR /devel/boost
RUN git submodule update --init --recursive
COPY . /devel/boost/libs/beast/

RUN ./bootstrap.sh
RUN ./b2 toolset=gcc variant=release cxxstd=latest headers
RUN ./tests.sh || true
