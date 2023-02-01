# --- build smart gateway ---
FROM registry.access.redhat.com/ubi8 AS builder
ENV GOPATH=/go
ENV D=/go/src/github.com/infrawatch/smart-gateway

WORKDIR $D
COPY . $D/
COPY build/repos/opstools.repo /etc/yum.repos.d/opstools.repo

RUN dnf install qpid-proton-c-devel git golang --setopt=tsflags=nodocs -y && \
    go build -o smart_gateway cmd/main.go && \
    mv smart_gateway /tmp/

# --- end build, create smart gateway layer ---