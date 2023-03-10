FROM ubuntu:bionic
## emulates Travis.ci environment
# Usage:
#   build:
#     docker build -f misc/Dockerfile.travis_emulate -t ngx_mruby:branch_name .
#   run:
#     docker run -it ngx_mruby:branch_name
#       or,
#     docker run -it -v `pwd`:/ngx_mruby ngx_mruby:branch_name

RUN echo "deb http://dk.archive.ubuntu.com/ubuntu/ xenial main" >> /etc/apt/sources.list && \
    echo "deb http://dk.archive.ubuntu.com/ubuntu/ xenial universe" >> /etc/apt/sources.list
RUN apt-get update
RUN apt-get install --no-install-recommends -y bash-completion apt-file software-properties-common && apt-file update && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository --yes ppa:ubuntu-toolchain-r/test && apt-get update
RUN apt-get install --no-install-recommends -y \
  build-essential wget libpcre3-dev psmisc \
  rake bison git gperf zlib1g-dev g++-4.9 libstdc++-4.9-dev \
  vim tmux curl && rm -rf /var/lib/apt/lists/*;

ENV CXX "g++-4.9"
ENV CC "gcc-4.9"
ENV LD "gcc-4.9"

ENV OPENSSL_SRC_VERSION "1.1.1i"

RUN curl -sfL https://www.openssl.org/source/openssl-${OPENSSL_SRC_VERSION}.tar.gz -o openssl-${OPENSSL_SRC_VERSION}.tar.gz && \
  mkdir openssl-${OPENSSL_SRC_VERSION} && tar -xzf openssl-${OPENSSL_SRC_VERSION}.tar.gz -C openssl-${OPENSSL_SRC_VERSION} --strip-components 1 && \
  rm openssl-${OPENSSL_SRC_VERSION}.tar.gz && \
  cd openssl-${OPENSSL_SRC_VERSION} && \
  ./config --prefix=/usr/local --shared zlib -fPIC >> /dev/null 2>&1 && \
  make && \
  make install && \
  ldconfig /usr/local/lib

## Add or -v `pwd`:/ngx_mruby
ADD . /ngx_mruby

WORKDIR /ngx_mruby
CMD ["/bin/bash"]

