# ansible-semaphore production image
FROM golang:1.18.3-alpine3.16 as builder


COPY ./ /go/src/github.com/ansible-semaphore/semaphore
WORKDIR /go/src/github.com/ansible-semaphore/semaphore

RUN apk add --no-cache -U libc-dev curl nodejs npm git && \
  ./deployment/docker/prod/bin/install

# Uses frolvlad alpine so we have access to glibc which is needed for golang
# and when deploying in openshift