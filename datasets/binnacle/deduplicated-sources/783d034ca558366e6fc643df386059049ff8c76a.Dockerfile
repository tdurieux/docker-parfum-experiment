# Build Container
FROM golang:1.11.4-alpine3.7 AS build-env
RUN apk add --no-cache --upgrade git openssh-client ca-certificates
RUN go get -u github.com/golang/dep/cmd/dep
WORKDIR /go/src/app

# Cache the dependencies early
COPY Gopkg.toml Gopkg.lock ./
RUN dep ensure -vendor-only -v

# Build
COPY *.go ./
RUN go build -o ./goaltdns *.go

# Final Container
FROM alpine:3.7
COPY --from=build-env /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=build-env /go/src/app/goaltdns /usr/bin/goaltdns
ADD words.txt /altdns/words.txt
ADD words2.txt /altdns/words2.txt
ENTRYPOINT ["/usr/bin/goaltdns"]
