FROM ubuntu:20.04

RUN apt-get update && apt-get install --no-install-recommends -y \
	iperf \
	iproute2 \
	net-tools \
	iptables \
	iproute2 \
	iputils-ping \
	inetutils-traceroute \
	netcat \
	dnsutils \
	tcpdump \
	netperf && rm -rf /var/lib/apt/lists/*;

ADD entrypoint.sh /usr/bin/entrypoint
RUN chmod +x /usr/bin/entrypoint

ENTRYPOINT ["/usr/bin/entrypoint"]
