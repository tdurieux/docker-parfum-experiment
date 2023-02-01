FROM ubuntu:latest
RUN apt-get update && apt-get install --no-install-recommends -y build-essential wget libgmp3-dev pkg-config libssl-dev && rm -rf /var/lib/apt/lists/*;
RUN wget https://cmake.org/files/v3.15/cmake-3.15.4.tar.gz \
  && tar zxfv cmake-3.15.4.tar.gz \
  && cd cmake-3.15.4 \
  && ./bootstrap \
  && make -j8 \
  && make install \
  && cd .. \
  && rm -rf cmake* && rm cmake-3.15.4.tar.gz
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
WORKDIR /usr/src/setup-tools
COPY . .
RUN mkdir build && cd build && cmake .. && make -j8
RUN ./build/test/setup_tests