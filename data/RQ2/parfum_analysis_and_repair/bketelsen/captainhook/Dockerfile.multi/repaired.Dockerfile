FROM golang:1.16 as builder
ADD . /go/src/github.com/bketelsen/captainhook
WORKDIR /go/src/github.com/bketelsen/captainhook
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o captainhook .

FROM alpine:latest as alpine
RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY --from=builder /go/src/github.com/bketelsen/captainhook/captainhook .


FROM scratch

COPY --from=alpine /root/captainhook /usr/bin/captainhook
COPY --from=alpine /etc/ssl/certs/ /etc/ssl/certs

VOLUME /config
ENTRYPOINT ["/usr/bin/captainhook"]
CMD ["/usr/bin/captainhook"]