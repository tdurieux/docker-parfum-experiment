FROM golang:alpine as builder

RUN apk update \
	&& apk add --no-cache make git \
	&& rm -rf /var/cache/apk/*

WORKDIR /go/src/virter
COPY . .

RUN make && mv ./virter /

FROM alpine:latest

COPY --from=builder /virter /opt/virter/

RUN apk update \
	&& apk add --no-cache rsync \
	&& rm -rf /var/cache/apk/*

WORKDIR /opt/virter
CMD ["-h"]
ENTRYPOINT ["/opt/virter/virter"]
