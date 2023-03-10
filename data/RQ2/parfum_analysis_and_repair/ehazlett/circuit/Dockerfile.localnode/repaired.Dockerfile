ARG IMAGE
FROM golang:alpine as build
RUN apk add --no-cache -U make git gcc bash btrfs-progs-dev libseccomp-dev build-base iptables bind-tools
RUN go get github.com/containerd/containerd
WORKDIR $GOPATH/src/github.com/containerd/containerd
RUN make && make install
RUN ./script/setup/install-runc
RUN ./script/setup/install-cni

ARG IMAGE
FROM ${IMAGE} as circuit

FROM alpine:latest
ENV CONTAINERD_SNAPSHOTTER=native
RUN apk add --no-cache -U libseccomp iptables
COPY --from=build /opt/cni/bin/ /opt/containerd/bin/
COPY --from=build /usr/local/sbin/runc /usr/local/sbin/runc
COPY --from=circuit /usr/local/bin/circuit /usr/local/bin/
COPY contrib/containerd/config.toml /etc/containerd/config.toml
COPY --from=build /usr/local/bin/ /usr/local/bin/
COPY contrib/localnode-start.sh /usr/local/bin/localnode.sh
ENTRYPOINT ["/usr/local/bin/localnode.sh"]
