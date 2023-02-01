FROM ubuntu:18.04

RUN apt-get update && apt-get install --no-install-recommends -y cmake git gcc g++ ninja-build build-essential && rm -rf /var/lib/apt/lists/*;

ENV TERM=xterm
ENV HOME /root
WORKDIR /root

COPY . /root/mockturtle
WORKDIR /root/mockturtle

RUN mkdir build-docker
WORKDIR /root/mockturtle/build-docker

RUN cmake -G Ninja -DMOCKTURTLE_TEST=ON ..
RUN ninja run_tests
RUN ./test/run_tests

CMD ["bash"]
