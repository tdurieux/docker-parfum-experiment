FROM ubuntu:21.04

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential \
    gcc-multilib \
    git \
    wget \
    clang \
    linux-headers-5.11.0-40 \
    libbpf-dev && rm -rf /var/lib/apt/lists/*;

RUN wget https://golang.org/dl/go1.17.3.linux-amd64.tar.gz
RUN tar -C /usr/local -xzf go1.17.3.linux-amd64.tar.gz && rm go1.17.3.linux-amd64.tar.gz
RUN cp /usr/local/go/bin/go /usr/bin/go

WORKDIR /delve-bpf/pkg/proc/internal/ebpf/

CMD [ "go", "generate", "./..." ]
