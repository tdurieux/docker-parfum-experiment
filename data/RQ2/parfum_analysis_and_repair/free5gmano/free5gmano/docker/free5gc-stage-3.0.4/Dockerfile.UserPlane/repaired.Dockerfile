FROM golang:1.14.4

WORKDIR /root/

RUN apt update -y && apt -y --no-install-recommends install git wget gcc cmake autoconf libtool pkg-config libmnl-dev libyaml-dev iputils-ping iptables tcpdump net-tools nano && rm -rf /var/lib/apt/lists/*;

WORKDIR $GOPATH/src
RUN git clone --recursive -b v3.0.4 -j `nproc` https://github.com/free5gc/free5gc.git

WORKDIR $GOPATH/src/free5gc
RUN go get -u github.com/sirupsen/logrus
RUN mkdir -p $GOPATH/src/free5gc/src/upf/build

WORKDIR $GOPATH/src/free5gc/src/upf/build
RUN cmake ..
RUN make -j`nproc`
