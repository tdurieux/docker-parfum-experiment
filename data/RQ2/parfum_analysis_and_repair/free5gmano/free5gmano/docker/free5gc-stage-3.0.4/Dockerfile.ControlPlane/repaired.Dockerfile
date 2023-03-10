FROM golang:1.14.4

WORKDIR /root/

RUN apt update -y && apt -y --no-install-recommends install wget git iputils-ping tcpdump net-tools nano && rm -rf /var/lib/apt/lists/*;

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

ENV GIN_MODE=release
