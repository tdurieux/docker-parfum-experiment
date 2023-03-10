FROM golang:latest as builder
LABEL maintainer="Bruce A. Mah <bmah@kitchenlab.org>"
WORKDIR /go/src/github.com/bmah888/gotesla
COPY . .
RUN go mod download
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o scimport cmd/scimport/main.go

FROM alpine:latest
RUN apk add --no-cache bash
WORKDIR /root
COPY --from=builder /go/src/github.com/bmah888/gotesla/scimport /
COPY --from=builder /go/src/github.com/bmah888/gotesla/cmd/scimport/docker-entrypoint.sh /
CMD ["/docker-entrypoint.sh"]