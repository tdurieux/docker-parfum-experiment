FROM golang:1.16.7-alpine3.14 as ndt-server-build
RUN apk add --no-cache git gcc linux-headers musl-dev openssl bash

ADD . /go/src/github.com/m-lab/ndt-server
ADD ./html /html

RUN /go/src/github.com/m-lab/ndt-server/build.sh
RUN cp /go/bin/ndt-server /
RUN cp /go/src/github.com/m-lab/ndt-server/gen_local_test_certs.bash /

WORKDIR /
CMD ["/ndt-server"]