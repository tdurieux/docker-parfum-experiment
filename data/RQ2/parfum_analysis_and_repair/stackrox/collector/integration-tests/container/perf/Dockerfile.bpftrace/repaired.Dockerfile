FROM quay.io/iovisor/bpftrace:latest

COPY /scripts /scripts
COPY /tools /tools

WORKDIR /root
ENTRYPOINT ["/scripts/run-tool.sh", "bpftrace"]