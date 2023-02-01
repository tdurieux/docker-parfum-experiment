# This file creates a container that runs a Caliopen mastodon worker
# Important:
# Author: Caliopen
# Date: 2019-07-12

FROM public-registry.caliopen.org/caliopen_go as builder

ADD . /go/src/github.com/CaliOpen/Caliopen/src/backend
WORKDIR /go/src/github.com/CaliOpen/Caliopen/src/backend

# Fetch dependencies needed for Caliopen GO apps
RUN govendor sync -v

RUN CGO_ENABLED=0 GOOS=linux go install -a -ldflags '-extldflags "-static"' github.com/CaliOpen/Caliopen/src/backend/protocols/go.mastodon/cmd/mastodonworker

FROM scratch
MAINTAINER Caliopen

# Add CA certificates