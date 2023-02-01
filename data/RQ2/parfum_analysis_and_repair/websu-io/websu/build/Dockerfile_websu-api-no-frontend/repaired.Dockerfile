FROM golang:1.14 AS builder

WORKDIR /go/src/github.com/websu-io/websu
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 go build ./cmd/websu-api && mv websu-api /

FROM alpine:3
ENV SERVE_FRONTEND=false
WORKDIR /websu
COPY --from=builder /websu-api /websu/websu-api
ADD templates /websu/templates
RUN apk --no-cache add ca-certificates
ENTRYPOINT ["/websu/websu-api"]
EXPOSE 8000/tcp