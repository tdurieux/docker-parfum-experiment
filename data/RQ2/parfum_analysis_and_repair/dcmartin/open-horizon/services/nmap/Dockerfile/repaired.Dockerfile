FROM ubuntu:bionic
RUN apt-get update && apt-get install --no-install-recommends -qq -y socat curl nmap gawk bc && rm -rf /var/lib/apt/lists/*;
COPY rootfs /
CMD ["/usr/bin/run.sh"]
