FROM quay.io/isovalent/hubble-llvm:2022-01-03-a6dfdaf as bpf-builder
WORKDIR /go/src/github.com/cilium/tetragon
RUN apt-get update  -y && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y linux-libc-dev && rm -rf /var/lib/apt/lists/*;
COPY . ./
RUN make tetragon-bpf

FROM quay.io/isovalent/hubble-libbpf:v0.2.3 as hubble-libbpf
WORKDIR /go/src/github.com/cilium/tetragon
COPY . ./

FROM quay.io/cilium/cilium-bpftool AS bpftool
COPY . ./


FROM golang:1.16
RUN apt-get update -y &&    \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y \
	linux-libc-dev \
	rpm2cpio \
	cpio \
	git \
	flex \
	bison \
	autoconf \
	libelf-dev \
	libcap-dev \
	bc \
	netcat-traditional \
	vim \
	file \
	strace \
	jq \
	less && rm -rf /var/lib/apt/lists/*;
COPY --from=bpf-builder /go/src/github.com/cilium/tetragon/bpf/objs/*.o /var/lib/tetragon/
COPY --from=hubble-libbpf /go/src/github.com/covalentio/hubble-fgs/src/libbpf.so.0.2.0 /usr/local/lib/
COPY --from=hubble-libbpf /go/src/github.com/covalentio/hubble-fgs/src/libbpf.so.0 /usr/local/lib/
COPY --from=hubble-libbpf /go/src/github.com/covalentio/hubble-fgs/src/libbpf.so /usr/local/lib/
COPY --from=hubble-libbpf /go/src/github.com/covalentio/hubble-fgs/src/libbpf.a /usr/local/lib/
COPY --from=bpftool  /bin/bpftool /usr/bin/
RUN ldconfig /usr/local/; export LD_LIBRARY_PATH=/usr/local/lib/
WORKDIR /go/src/github.com/cilium/tetragon
COPY . ./
RUN make tetragon tetra test-compile contrib-progs


ENV TETRAGON_PROCFS=/procRoot/
ENV LD_LIBRARY_PATH=/usr/local/lib/
# CMD ["sh", "-c", "/go/src/github.com/cilium/tetragon/tetragon --procfs=/procRoot/ --export-filename=/tmp/tetragon.log --metrics-server :2112 --verbose 4"]
CMD ["sh", "-c", "/go/src/github.com/cilium/tetragon/tetragon --procfs=/procRoot/"]
