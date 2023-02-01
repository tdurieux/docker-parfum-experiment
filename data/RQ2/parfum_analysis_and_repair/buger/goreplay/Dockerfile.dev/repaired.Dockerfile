FROM golang:1.17

RUN apt-get update && apt-get install --no-install-recommends ruby vim-common -y && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends flex bison -y && rm -rf /var/lib/apt/lists/*;
RUN wget https://www.tcpdump.org/release/libpcap-1.10.0.tar.gz && tar xzf libpcap-1.10.0.tar.gz && cd libpcap-1.10.0 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make install && rm libpcap-1.10.0.tar.gz

RUN go get github.com/google/gopacket
RUN go get -u golang.org/x/lint/golint

WORKDIR /go/src/github.com/buger/goreplay/
ADD . /go/src/github.com/buger/goreplay/

RUN go get
