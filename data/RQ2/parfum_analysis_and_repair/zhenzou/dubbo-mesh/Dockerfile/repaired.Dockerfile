# Builder container
FROM golang AS builder

WORKDIR /go/src/dubbo-mesh
COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build --tags "jsoniter prod" -o /root/mesh/agent/consumer ./cmd/consumer/main.go
RUN CGO_ENABLED=0 GOOS=linux go build --tags "jsoniter prod" -o /root/mesh/agent/provider ./cmd/provider/main.go

# Runner container