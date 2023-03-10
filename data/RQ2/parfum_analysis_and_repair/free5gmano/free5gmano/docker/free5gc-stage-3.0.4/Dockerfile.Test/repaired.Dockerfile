FROM golang:1.14.4

RUN apt -y update && apt -y --no-install-recommends install wget git iputils-ping tcpdump net-tools nano make iproute2 && rm -rf /var/lib/apt/lists/*;

WORKDIR $GOPATH/src
RUN git clone --recursive -b v3.0.4 -j `nproc` https://github.com/free5gc/free5gc.git

WORKDIR $GOPATH/src/free5gc
RUN git checkout master
RUN git submodule sync
RUN git submodule update --init --jobs `nproc`
RUN git submodule foreach git checkout master
RUN git submodule foreach git pull --jobs `nproc`
RUN go mod download

WORKDIR $GOPATH/src/free5gc/src/test

COPY ./*.go ./

ENV GIN_MODE=release