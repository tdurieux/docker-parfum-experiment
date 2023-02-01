FROM golang:1.17.1-bullseye

ARG DEBIAN_FRONTEND=noninteractive
RUN \
  apt-get update && \
  apt-get install -y xorg-dev && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

WORKDIR /usr/local/src/go2tv/
COPY . .

ENV GODEBUG=asyncpreemptoff=1
RUN make
RUN make install

ENTRYPOINT [ "go2tv" ]
