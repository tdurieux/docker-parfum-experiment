# stage 1, which can go as a basic go build image runtime
FROM alpine:latest AS builder
RUN apk --no-cache add make git go gcc libtool musl-dev

# Configure Go
ENV GOROOT /usr/lib/go
ENV GOPATH /go
ENV PATH /go/bin:$PATH

RUN mkdir -p ${GOPATH}/src ${GOPATH}/bin

COPY go.mod .
COPY go.sum .

# The next line can be removed once the profile go.mod's are merged into master
COPY profile profile
RUN go mod download
COPY . /
RUN make ; rm -rf $GOPATH/pkg/mod

# stage 2,, which can go as a basic runtime
FROM alpine:latest
RUN apk --no-cache add make git go gcc libtool musl-dev
# Configure Go for the micro runtime
ENV GOROOT /usr/lib/go
ENV GOPATH /go
ENV PATH /go/bin:$PATH
RUN mkdir -p ${GOPATH}/src ${GOPATH}/bin

RUN apk --no-cache add ca-certificates && \
  rm -rf /var/cache/apk/* /tmp/* && \
  [ ! -e /etc/nsswitch.conf ] && echo 'hosts: files dns' > /etc/nsswitch.conf

COPY --from=builder /auth /auth

ENTRYPOINT [ "/auth" ]
