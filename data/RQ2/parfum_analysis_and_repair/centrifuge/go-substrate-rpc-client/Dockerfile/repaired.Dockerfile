FROM golang:1.18

RUN apt-get -y update && apt-get -y upgrade && apt-get -y --no-install-recommends install wget && apt-get install --no-install-recommends ca-certificates -y && rm -rf /var/lib/apt/lists/*;

RUN go version

RUN mkdir -p /go-substrate-rpc-client
WORKDIR /go-substrate-rpc-client

# Reset parent entrypoint
ENTRYPOINT []
CMD ["make", "test-cover"]
