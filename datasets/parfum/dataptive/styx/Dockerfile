FROM golang AS builder

WORKDIR /go/src/github.com/dataptive/styx

COPY . .

RUN CGO_ENABLED=0 go build -o $GOPATH/bin/styx ./cmd/styx 
RUN CGO_ENABLED=0 go build -o $GOPATH/bin/styx-server ./cmd/styx-server

FROM alpine:latest  
WORKDIR /

COPY --from=builder /go/src/github.com/dataptive/styx/config.toml /etc/styx/config.toml
COPY --from=builder /go/bin /usr/bin

RUN mkdir data

ENTRYPOINT ["styx-server", "--config", "/etc/styx/config.toml", "--log-level", "INFO"]

EXPOSE 7123
