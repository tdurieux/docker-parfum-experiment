# We need alpine edge for libseccomp-2.5.0

FROM golang:1.17-alpine as builder
RUN apk add --no-cache alpine-sdk

RUN \
	sed -i -e 's/v[[:digit:]]\..*\//edge\//g' /etc/apk/repositories && \
	apk add --no-cache libseccomp libseccomp-dev

RUN mkdir /build
ADD . /build/
WORKDIR /build
RUN go build -o seccompagent ./cmd/seccompagent

FROM alpine:edge
RUN apk add --no-cache libseccomp
COPY --from=builder /build/seccompagent /bin/seccompagent

CMD ["/bin/seccompagent", "-resolver=kubernetes"]
