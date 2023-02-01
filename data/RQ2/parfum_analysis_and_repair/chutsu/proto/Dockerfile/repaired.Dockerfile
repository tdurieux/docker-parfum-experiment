FROM ubuntu:18.04

RUN apt-get update && apt-get install --no-install-recommends -qqy sudo lsb-release build-essential git && rm -rf /var/lib/apt/lists/*;

WORKDIR /app
RUN git clone https://github.com/chutsu/proto
WORKDIR /app/proto
RUN make deps
RUN make release
RUN make install
