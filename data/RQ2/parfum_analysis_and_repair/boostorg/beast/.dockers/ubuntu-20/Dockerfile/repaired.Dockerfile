FROM ubuntu:20.04

RUN apt-get update
RUN DEBIAN_FRONTEND="noninteractive" apt-get --no-install-recommends -y install tzdata && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y git cmake libssl-dev clang libc++-10-dev libc++abi-10-dev libbz2-dev zlib1g-dev mlocate && rm -rf /var/lib/apt/lists/*;

WORKDIR /devel
RUN git clone -b develop https://github.com/boostorg/boost.git
COPY .dockers/ubuntu-20/user-config.jam /devel/boost/
COPY .dockers/ubuntu-20/tests.sh /devel/boost/

WORKDIR /devel/boost
RUN git submodule update --init --recursive
COPY . /devel/boost/libs/beast/

RUN ./bootstrap.sh
RUN ./b2 toolset=gcc variant=release cxxstd=latest headers
RUN ./tests.sh || true
