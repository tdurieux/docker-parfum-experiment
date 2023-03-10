FROM golang:1.15 AS builder
RUN apt-get update && apt-get install --no-install-recommends -y default-mysql-client && rm -rf /var/lib/apt/lists/*;
WORKDIR /go/src/github.com/putdotio/efes/
ENV GO111MODULE=on
COPY go.mod .
COPY go.sum .
RUN go mod download
ADD docker-run-tests.sh /root/run-tests.sh
COPY . .
ADD config-docker.toml /etc/efes.toml
ENTRYPOINT ["/bin/bash", "/root/run-tests.sh"]
