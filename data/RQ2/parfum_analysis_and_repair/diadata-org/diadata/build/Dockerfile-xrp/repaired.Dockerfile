FROM golang:1.14 as build

WORKDIR $GOPATH

COPY . .

WORKDIR $GOPATH/src/github.com/diadata-org/diadata/internal/pkg/blockchain-scrapers/blockchains/ripple/scrapers/xrp

RUN go install

FROM gcr.io/distroless/base

COPY --from=build /go/bin/xrp /bin/xrp

CMD ["xrp"]