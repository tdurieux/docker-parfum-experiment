FROM ubuntu:18.10

ENV DEBIAN_FRONTEND noninteractive
ENV TZ Europe/Madrid

RUN apt-get update
RUN apt-get install --no-install-recommends -y libssh2-1-dev curl gdb cppcheck xz-utils sudo libtinfo5 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y cmake libssl-dev pkg-config zlib1g-dev clang tzdata git vim && rm -rf /var/lib/apt/lists/*;

COPY . /opt
RUN cd /opt && ./build-libgit2.sh
