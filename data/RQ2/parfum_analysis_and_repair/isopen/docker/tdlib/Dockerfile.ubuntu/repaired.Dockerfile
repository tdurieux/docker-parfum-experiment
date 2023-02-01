FROM ubuntu:16.04

RUN apt-get update && apt-get install --no-install-recommends -y g++ ccache openssl libssl-dev cmake gperf make git libreadline-dev zlib1g-dev && rm -rf /var/lib/apt/lists/*;

WORKDIR /
COPY . /td

WORKDIR /td
RUN mkdir build
WORKDIR build
RUN cmake -DCMAKE_BUILD_TYPE=Release ..
RUN cmake --build .
