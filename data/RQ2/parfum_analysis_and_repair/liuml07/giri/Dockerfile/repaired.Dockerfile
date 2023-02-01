FROM ubuntu

MAINTAINER Mingliang Liu <liuml07@gmail.com>

ENV LLVM_HOME /usr/local/llvm
ENV BuildMode Release+Asserts
ENV TEST_PARALLELISM seq

RUN apt-get update && apt-get install --no-install-recommends -qq -y wget make g++ python zip unzip autoconf libtool automake && rm -rf /var/lib/apt/lists/*;
RUN apt-get upgrade -y


ADD . giri

RUN giri/utils/install_llvm.sh 3.4

RUN cd giri/ && utils/build.sh
