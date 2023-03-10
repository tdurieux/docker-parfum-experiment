FROM golang:1.14 as build

WORKDIR $GOPATH

COPY . .

WORKDIR $GOPATH/src/github.com/diadata-org/diadata/internal/pkg/blockchain-scrapers/blockchains/neo/scrapers/neo

RUN go install

FROM gcr.io/distroless/base

COPY --from=build /go/bin/neo /bin/neo

CMD ["neo"]