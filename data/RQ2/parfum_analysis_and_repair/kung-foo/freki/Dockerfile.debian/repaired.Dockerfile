FROM golang:1.8

RUN apt-get update && apt-get install --no-install-recommends -yq libpcap-dev libnetfilter-queue-dev && rm -rf /var/lib/apt/lists/*;
RUN go get golang.org/x/net/bpf
RUN go get golang.org/x/net/context
RUN go get golang.org/x/net/proxy
