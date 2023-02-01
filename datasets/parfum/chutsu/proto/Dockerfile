FROM ubuntu:18.04

RUN apt-get update
RUN apt-get install -qqy sudo lsb-release build-essential git

WORKDIR /app
RUN git clone https://github.com/chutsu/proto
WORKDIR /app/proto
RUN make deps
RUN make release
RUN make install
