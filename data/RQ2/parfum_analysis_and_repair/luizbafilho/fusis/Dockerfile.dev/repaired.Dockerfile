FROM golang:1.9.1

RUN apt update -y && \
    apt install --no-install-recommends -y iptables kmod ipvsadm make && rm -rf /var/lib/apt/lists/*;
