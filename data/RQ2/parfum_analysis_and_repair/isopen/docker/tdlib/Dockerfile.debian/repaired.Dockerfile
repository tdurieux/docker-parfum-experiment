FROM debian:9

RUN apt-get -y update && apt-get install --no-install-recommends -y g++ ccache openssl cmake gperf make git libssl-dev libreadline-dev zlib1g zlib1g-dev && rm -rf /var/lib/apt/lists/*;

WORKDIR /
COPY . /td

WORKDIR /td
RUN mkdir build
WORKDIR build
RUN cmake -DCMAKE_BUILD_TYPE=Release ..
RUN cmake --build .
