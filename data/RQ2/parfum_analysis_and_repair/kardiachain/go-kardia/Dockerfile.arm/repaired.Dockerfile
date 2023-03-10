FROM public.ecr.aws/x4e9f8w5/go-kardia:golang
RUN mkdir -p "$GOPATH/src/github.com/kardiachain/go-kardia"
WORKDIR /go/src/github.com/kardiachain/go-kardia
RUN apt-get update && apt-get install --no-install-recommends -y libzmq3-dev && rm -rf /var/lib/apt/lists/*;
ADD . .
WORKDIR /go/src/github.com/kardiachain/go-kardia/cmd
RUN go install
WORKDIR /go/src/github.com/kardiachain/go-kardia/dualnode/eth/eth_client
RUN go install
WORKDIR /go/bin
RUN mkdir -p /go/bin/cfg
COPY cmd/cfg /go/bin/cfg
ENTRYPOINT ["./cmd"]
