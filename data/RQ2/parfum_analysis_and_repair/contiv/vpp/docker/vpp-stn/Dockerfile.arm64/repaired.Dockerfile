FROM arm64v8/golang:1.13.8-alpine3.10 as builder

# we want a static binary
ENV CGO_ENABLED=0

RUN apk add --no-cache --update git make

COPY . /go/src/github.com/contiv/vpp

WORKDIR /go/src/github.com/contiv/vpp

RUN make contiv-stn

FROM scratch

COPY --from=builder /go/src/github.com/contiv/vpp/cmd/contiv-stn/contiv-stn /contiv-stn

ENTRYPOINT ["/contiv-stn"]
