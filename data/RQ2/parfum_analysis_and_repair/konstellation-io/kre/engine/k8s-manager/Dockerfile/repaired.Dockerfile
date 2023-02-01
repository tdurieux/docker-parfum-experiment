# Generate proto
FROM grpc/go as protobuf

WORKDIR /app

COPY scripts scripts

COPY proto proto

RUN ./scripts/generate_proto.sh


# Build k8s-manager
FROM golang:1.18.1-alpine3.15 as builder

ENV CGO_ENABLED=0

WORKDIR /app
COPY go.* ./
RUN go mod download
COPY . .
RUN rm -rf /app/proto
COPY --from=protobuf /app/proto/ /app/proto/

RUN go build -o k8s-manager .


# Final image
FROM alpine:3.10.2

# Create kre user.