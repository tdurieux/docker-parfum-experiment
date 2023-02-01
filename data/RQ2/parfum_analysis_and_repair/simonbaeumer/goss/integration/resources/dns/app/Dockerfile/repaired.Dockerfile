FROM ubuntu:18.04

RUN apt-get update && apt-get install --no-install-recommends -y \
        dnsutils \
        iproute2 \
        iputils-ping \
        vim && rm -rf /var/lib/apt/lists/*;

COPY resolv.conf /etc/resolv.conf

CMD ["/bin/bash"]