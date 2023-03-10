FROM golang:1.16 as builder
WORKDIR /workspace

# Build cnsenter
ARG VERSION
COPY . .
RUN CGO_ENABLED=0 GO111MODULE=on go build -a -ldflags="-X 'github.com/ssup2/kpexec/pkg/cmd/cnsenter.version=${VERSION}'" -o cnsenter cmd/cnsenter/main.go

# Build image
# Reference - https://github.com/nicolaka/netshoot
FROM alpine:3.13.1
COPY --from=builder /workspace/cnsenter /usr/bin/cnsenter
COPY scripts/remount-proc-exec /usr/bin/remount-proc-exec
RUN apk add --no-cache \
	apache2-utils \
	bash \
	bind-tools \
	conntrack-tools \
	curl \
	dhcping \
	drill \
	ethtool \
	htop \
	iftop \
	iperf \
	iproute2 \
	ipset \
	iptables \
	iputils \
	jq \
	nano \
	net-tools \
	net-snmp-tools \
	nftables \
	nmap \
	nmap-ncat \
	nmap-nping \
	openssl \
	socat \
	tcpdump \
	tcptraceroute \
	tshark \
	vim \
	wrk

CMD ["cnsenter"]
