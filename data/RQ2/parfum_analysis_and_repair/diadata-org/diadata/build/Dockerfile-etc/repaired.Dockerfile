FROM golang:1.14 as build

WORKDIR $GOPATH

COPY . .

WORKDIR $GOPATH/src/github.com/diadata-org/diadata/internal/pkg/blockchain-scrapers/blockchains/ethereum-classic/scrapers/etc

RUN go install

FROM gcr.io/distroless/base

COPY --from=build /go/bin/etc /bin/etc

ENTRYPOINT ["etc"]