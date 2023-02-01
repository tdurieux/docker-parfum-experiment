FROM debian:buster
ENV  DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get install dialog apt-utils -y --no-install-recommends && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends git-core python-dev libxml2-dev libxslt-dev -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends tree zip wget gcc-8 g++-8 make libssl-dev -y && rm -rf /var/lib/apt/lists/*;
RUN update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-8 40
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 40

RUN wget https://github.com/Kitware/CMake/releases/download/v3.20.0/cmake-3.20.0-linux-x86_64.sh -O cmake.sh \
      && chmod u+x cmake.sh \
      && mkdir /usr/bin/cmake \
      && ./cmake.sh --skip-license --prefix=/usr/bin/cmake \
      && rm cmake.sh

ENV PATH="/usr/bin/cmake/bin:${PATH}"