FROM golang:1.11

ENV BIN_DIR="/go/bin"
ENV CGO_ENABLED=1
ENV GOOS=linux

RUN apt-get update && apt-get -y --no-install-recommends install jq lsof nmap tcpdump vim && apt-get clean all && rm -rf /var/lib/apt/lists/*;

ADD . /go/src/github.com/insolar/insolar
WORKDIR /go/src/github.com/insolar/insolar
RUN rm -Rf /go/src/github.com/insolar/insolar/vendor/* && make install-deps && make pre-build && mv /go/src/github.com/insolar/insolar/vendor /go/
