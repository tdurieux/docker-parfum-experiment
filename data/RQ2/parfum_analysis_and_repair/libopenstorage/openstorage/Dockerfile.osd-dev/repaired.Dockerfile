FROM docker.io/openstorage/osd-dev-base:1.16
MAINTAINER gou@portworx.com

EXPOSE 9005
ADD . /go/src/github.com/libopenstorage/openstorage/
WORKDIR /go/src/github.com/libopenstorage/openstorage