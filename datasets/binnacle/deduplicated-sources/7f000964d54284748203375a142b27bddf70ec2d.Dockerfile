FROM golang:alpine as build-env

RUN apk add git

# Copy source + vendor
COPY . /go/src/github.com/messagebird/beanstalkd_exporter
WORKDIR /go/src/github.com/messagebird/beanstalkd_exporter

# Build
ENV GOPATH=/go
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 GO111MODULE=off go build -v -a -ldflags "-s -w" -o /go/bin/beanstalkd_exporter .

# Build mininal image with compiled app
FROM scratch
COPY examples/ /etc/beanstalkd_exporter/
COPY --from=build-env /go/bin/beanstalkd_exporter /usr/bin/beanstalkd_exporter
ENTRYPOINT ["beanstalkd_exporter"]
CMD ["-beanstalkd.address", "beanstalkd:11300"]
