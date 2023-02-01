FROM ubuntu:xenial
RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    curl \
    iptables \
    iproute2 \
    iputils-ping \
    dnsutils \
    netcat \
    tcpdump \
    net-tools \
    libc6-dbg gdb valgrind \
    vim \
    wrk \
    lsof \
    busybox \
    sudo && rm -rf /var/lib/apt/lists/*;

ADD nodeagent.sh /usr/local/bin/
ADD nodeagent /usr/local/bin/

RUN chmod +x /usr/local/bin/nodeagent.sh

ENTRYPOINT ["/usr/local/bin/nodeagent.sh"]
