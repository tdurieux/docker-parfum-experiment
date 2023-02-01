FROM gcr.io/linkerd-io/base:2019-02-19.01
RUN apt-get update && apt-get install -y --no-install-recommends \
    tcpdump \
    iproute2 \
    lsof \
    tshark && \
    rm -rf /var/lib/apt/lists/*
ENTRYPOINT [ "tshark", "-i", "any" ]
