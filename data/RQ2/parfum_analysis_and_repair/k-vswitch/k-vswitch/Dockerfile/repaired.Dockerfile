FROM debian:stretch-slim

RUN apt update && apt install --no-install-recommends -y openvswitch-switch iptables && rm -rf /var/lib/apt/lists/*;

ADD bin/k-vswitchd /bin
ADD bin/k-vswitch-cni /bin
ADD bin/k-vswitch-controller /bin

CMD ["/bin/k-vswitchd"]
