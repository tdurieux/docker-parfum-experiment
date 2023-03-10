# Golang binary building stage
FROM golang:1.16
WORKDIR $GOPATH/src/github.com/nats-io/prometheus-nats-exporter
RUN git clone --branch v0.8.0 https://github.com/nats-io/prometheus-nats-exporter.git .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -v -a -tags netgo -installsuffix netgo -ldflags "-s -w"

# Final docker image building stage