FROM golang:1.12.9

WORKDIR /root/

RUN apt update -y && apt -y --no-install-recommends install git wget gcc cmake autoconf libtool pkg-config libmnl-dev libyaml-dev && rm -rf /var/lib/apt/lists/*;

WORKDIR $GOPATH/src
RUN git clone https://github.com/free5gc/free5gc-stage-2.git free5gc

WORKDIR $GOPATH/src/free5gc
RUN go get -u github.com/sirupsen/logrus
RUN mkdir -p $GOPATH/src/free5gc/src/upf/build

WORKDIR $GOPATH/src/free5gc/src/upf/build
RUN cmake ..
RUN make -j `nproc`