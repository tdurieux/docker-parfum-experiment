FROM alpine

RUN apk update; apk add --no-cache socat netcat-openbsd curl jq postgresql-client ngrep

COPY ./consul /usr/local/bin/consul
COPY ./consul_server.hcl /etc/consul.d/consul.hcl

ENTRYPOINT consul agent -config-file /etc/consul.d/consul.hcl -config-format hcl -client 0.0.0.0

# Server RPC is used for communication between Consul clients and servers for internal
# request forwarding.
EXPOSE 8300

# Serf LAN and WAN (WAN is used only by Consul servers) are used for gossip between
# Consul agents. LAN is within the datacenter and WAN is between just the Consul
# servers in all datacenters.
EXPOSE 8301 8301/udp 8302 8302/udp

# HTTP and DNS (both TCP and UDP) are the primary interfaces that applications
# use to interact with Consul.
EXPOSE 8500 8600 8600/udp
