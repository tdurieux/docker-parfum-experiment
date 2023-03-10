FROM golang:1.14 as build

WORKDIR $GOPATH/src/

COPY . .

WORKDIR $GOPATH/src/github.com/diadata-org/diadata/cmd/ratescrapers

RUN go install

FROM gcr.io/distroless/base

COPY --from=build /go/bin/ratescrapers /bin/ratescrapers

CMD ["ratescrapers"]