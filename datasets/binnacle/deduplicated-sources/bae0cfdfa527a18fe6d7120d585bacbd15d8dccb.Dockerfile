FROM golang:1.10 as build

RUN mkdir -p /go/src/github.com/openfaas-incubator/kafka-connector/producer
WORKDIR /go/src/github.com/openfaas-incubator/kafka-connector/producer

COPY vendor     vendor
COPY main.go    main.go

# Run a gofmt and exclude all vendored code.
RUN test -z "$(gofmt -l $(find . -type f -name '*.go' -not -path "./vendor/*"))"

# RUN go test -v ./...

# Stripping via -ldflags "-s -w" 
RUN CGO_ENABLED=0 GOOS=linux go build -a -ldflags "-s -w" -installsuffix cgo -o /usr/bin/producer

FROM alpine:3.9 as ship

COPY --from=build /usr/bin/producer /usr/bin/producer
WORKDIR /usr/bin/

CMD ["./producer"]
