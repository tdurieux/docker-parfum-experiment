FROM golang:latest
RUN apt-get -qq update && \
    apt-get install -y --no-install-recommends -qq libpcap-dev \
    build-essential \
    vim && rm -rf /var/lib/apt/lists/*;
ADD . /go/src/github.com/k1LoW/tcpdp
WORKDIR /go/src/github.com/k1LoW/tcpdp
