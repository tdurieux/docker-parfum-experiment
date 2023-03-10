FROM ubuntu:21.04 as libbtf
RUN apt-get -y install

FROM quay.io/isovalent/hubble-libbpf:v0.2.2 as hubble-libbpf
WORKDIR /go/src/github.com/cilium/tetragon

FROM docker.io/golangci/golangci-lint:v1.45.2
COPY --from=hubble-libbpf /go/src/github.com/covalentio/hubble-fgs/src/*.h /usr/include/
COPY --from=hubble-libbpf /go/src/github.com/covalentio/hubble-fgs/src/*.a /usr/local/lib
COPY --from=hubble-libbpf /go/src/github.com/covalentio/hubble-fgs/src/*.so /usr/local/lib
COPY --from=hubble-libbpf /go/src/github.com/covalentio/hubble-fgs/src/*.so.* /usr/local/lib
RUN apt-get -y update
RUN apt-get -y --no-install-recommends install libz-dev libelf-dev && rm -rf /var/lib/apt/lists/*;

#- vi: ft=dockerfile -#
