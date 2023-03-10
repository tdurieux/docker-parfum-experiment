FROM ubuntu:18.04

RUN apt -y update && apt -y --no-install-recommends install mongodb wget git iputils-ping tcpdump net-tools nano make iproute2 && rm -rf /var/lib/apt/lists/*;

WORKDIR /
RUN mkdir /data
RUN mkdir /data/db

RUN service mongodb start

RUN wget https://dl.google.com/go/go1.14.4.linux-amd64.tar.gz
RUN tar -C /usr/local -zxvf go1.14.4.linux-amd64.tar.gz && rm go1.14.4.linux-amd64.tar.gz
RUN mkdir -p ~/go/{bin,pkg,src}
ENV GOPATH=$HOME/go
ENV GOROOT=/usr/local/go
ENV PATH=$PATH:$GOPATH/bin:$GOROOT/bin

WORKDIR $GOPATH/src
RUN git clone --recursive -b v3.0.4 -j `nproc` https://github.com/free5gc/free5gc.git

WORKDIR $GOPATH/src/free5gc
RUN git checkout master
RUN git submodule sync
RUN git submodule update --init --jobs `nproc`
RUN git submodule foreach git checkout master
RUN git submodule foreach git pull --jobs `nproc`
RUN go mod download
RUN make amf
RUN make ausf
RUN make nrf
RUN make nssf
RUN make pcf
RUN make smf
RUN make udm
RUN make udr

WORKDIR $GOPATH/src/free5gc/src/test

ENV GIN_MODE=release

