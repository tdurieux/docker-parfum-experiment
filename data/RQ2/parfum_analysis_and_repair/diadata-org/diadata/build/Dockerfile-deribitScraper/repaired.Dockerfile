FROM golang:1.14 as build

WORKDIR $GOPATH/src/

COPY . .

WORKDIR $GOPATH/src/github.com/diadata-org/diadata/cmd/exchange-scrapers/options
RUN go install

FROM gcr.io/distroless/base

COPY --from=build /go/bin/options /bin/options

CMD ["options"]