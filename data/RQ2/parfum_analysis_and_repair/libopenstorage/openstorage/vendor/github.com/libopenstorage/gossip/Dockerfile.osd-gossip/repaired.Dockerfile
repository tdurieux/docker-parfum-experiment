FROM quay.io/openstorage/osd-dev-base
MAINTAINER gou@portworx.com

EXPOSE 9005
ADD . /go/src/github.com/libopenstorage/gossip
WORKDIR /go/src/github.com/libopenstorage/gossip