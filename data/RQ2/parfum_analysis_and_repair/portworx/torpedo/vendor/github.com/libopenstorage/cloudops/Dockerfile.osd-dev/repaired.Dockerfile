FROM quay.io/openstorage/osd-dev-base
MAINTAINER support@portworx.com

ADD . /go/src/github.com/libopenstorage/cloudops/
WORKDIR /go/src/github.com/libopenstorage/cloudops