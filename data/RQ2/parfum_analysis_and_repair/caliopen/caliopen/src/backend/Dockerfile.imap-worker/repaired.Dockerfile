# This file creates a container that runs a Caliopen identity worker
# Important:
# Author: Caliopen
# Date: 2018-07-20

FROM public-registry.caliopen.org/caliopen_go as builder

ADD . /go/src/github.com/CaliOpen/Caliopen/src/backend
WORKDIR /go/src/github.com/CaliOpen/Caliopen/src/backend

# Fetch dependencies needed for Caliopen GO apps
RUN govendor sync -v

RUN CGO_ENABLED=0 GOOS=linux go install -a -ldflags '-extldflags "-static"' github.com/CaliOpen/Caliopen/src/backend/protocols/go.imap/cmd/imapworker
RUN CGO_ENABLED=0 GOOS=linux go install -a -ldflags '-extldflags "-static"' github.com/CaliOpen/Caliopen/src/backend/protocols/go.imap/cmd/imapctl

FROM scratch
MAINTAINER Caliopen

# Add CA certificates