FROM hone/mruby-cli

RUN apt-get update && \
    apt-get install -y --no-install-recommends software-properties-common && \
    add-apt-repository ppa:george-edison55/cmake-3.x && \
    apt-get update && \
    apt-get upgrade -y cmake && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:ubuntu-toolchain-r/test && \
    apt-get update && \
    apt-get install --no-install-recommends g++-4.9 gcc-4.9 clang-3.6 -y && \
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.9 60 --slave /usr/bin/g++ g++ /usr/bin/g++-4.9 && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && \
  apt-get install --no-install-recommends python -y && rm -rf /var/lib/apt/lists/*;

RUN gem install bundler

RUN mkdir -p /opt && \
  cd /opt && \
  curl -f -s "https://nodejs.org/dist/v5.7.0/node-v5.7.0-linux-x64.tar.xz" -o - | tar xJ
ENV PATH /opt/node-v5.7.0-linux-x64/bin:/home/mruby/.gem/bin:$PATH
