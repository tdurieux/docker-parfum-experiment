FROM golang:1.16-alpine3.14

RUN apk add --no-cache ca-certificates openssl

WORKDIR /usr/local/src/rawdns

COPY go.mod go.sum ./
RUN set -eux; \
	go mod download; \
	go mod verify

COPY . .

RUN go build -v -o /usr/local/bin/rawdns ./cmd/rawdns

CMD ["rawdns"]
