FROM golang:1.13-alpine

COPY . /go/src/github.com/honeycombio/rdslogs
WORKDIR /go/src/github.com/honeycombio/rdslogs
RUN apk update && apk add --no-cache git
RUN go get ./...
RUN go install ./...

FROM golang:1.9-alpine
COPY --from=0 /go/bin/rdslogs /rdslogs
ENTRYPOINT ["/rdslogs"]
