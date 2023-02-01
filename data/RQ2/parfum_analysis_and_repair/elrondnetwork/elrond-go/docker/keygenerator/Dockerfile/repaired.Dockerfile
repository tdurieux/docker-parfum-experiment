FROM golang:1.15.7 as builder
MAINTAINER ElrondNetwork

RUN apt-get update && apt-get install --no-install-recommends -y && rm -rf /var/lib/apt/lists/*;
WORKDIR /go/elrond-go
COPY . .
RUN GO111MODULE=on go mod vendor
# Keygenerator node
WORKDIR /go/elrond-go/cmd/keygenerator
RUN go build

# ===== SECOND STAGE ======
FROM ubuntu:18.04
COPY --from=builder /go/elrond-go/cmd/keygenerator /go/elrond-go/cmd/keygenerator

WORKDIR /go/elrond-go/cmd/keygenerator/
ENTRYPOINT ["./keygenerator"]
