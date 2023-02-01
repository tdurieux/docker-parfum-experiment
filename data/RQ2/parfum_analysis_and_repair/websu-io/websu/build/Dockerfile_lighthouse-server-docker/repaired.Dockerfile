FROM golang:1.14 AS builder

WORKDIR /go/src/github.com/websu-io/websu
COPY go.mod go.sum ./
# Download dependencies and cache in docker layer
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 go build ./cmd/lighthouse-server && mv lighthouse-server /

FROM alpine:3
ENV USE_DOCKER=true
WORKDIR /websu
RUN apk add --update --no-cache docker
COPY --from=builder /lighthouse-server /websu/lighthouse-server

ENTRYPOINT ["/websu/lighthouse-server"]
EXPOSE 50051/tcp