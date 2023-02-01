FROM golang:latest as builder

WORKDIR /tmp/cirrus-ci-agent
ADD . /tmp/cirrus-ci-agent/

RUN echo 'deb [trusted=yes] https://repo.goreleaser.com/apt/ /' | tee /etc/apt/sources.list.d/goreleaser.list
RUN apt-get update && apt-get -y --no-install-recommends install goreleaser && rm -rf /var/lib/apt/lists/*;
RUN goreleaser build --single-target --snapshot

FROM alpine:latest

RUN apk add --no-cache rsync
COPY --from=builder /tmp/cirrus-ci-agent/dist/agent_linux_*/agent /bin/cirrus-ci-agent
