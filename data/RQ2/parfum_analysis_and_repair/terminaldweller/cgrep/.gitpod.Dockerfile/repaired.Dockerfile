FROM gitpod/workspace-full

# Install custom tools, runtimes, etc.
# For example "bastet", a command-line tetris clone:
# RUN brew install bastet
#
# More information: https://www.gitpod.io/docs/config-docker/
FROM ubuntu:20.04
RUN apt update && apt upgrade -y
ENV TERM=xterm-256color
RUN DEBIAN_FRONTEND="noninteractive" apt-get --no-install-recommends -y install tzdata && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends wget subversion gnupg2 software-properties-common make git xterm libffi7 -y && rm -rf /var/lib/apt/lists/*;

RUN wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - \
      && add-apt-repository "deb http://apt.llvm.org/bionic/   llvm-toolchain-bionic-9  main" \
      && apt-get update \
      && apt-get install --no-install-recommends clang-9 llvm-9-dev libclang-common-9-dev libclang-9-dev libllvm9 -y && rm -rf /var/lib/apt/lists/*;

RUN git clone https://github.com/bloodstalker/cgrep \
      && cd cgrep \
      && git submodule init \
      && git submodule update \
      && make CXX=clang-9 LLVM_CONF=llvm-config-9

RUN mkdir devi
WORKDIR /devi