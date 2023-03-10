FROM alpine:3.12.3
RUN apk upgrade --no-cache && \
  apk --no-cache add openvswitch logrotate conntrack-tools tcpdump curl strace \
  ltrace iptables net-tools
COPY docker/launch-ovs.sh docker/liveness-ovs.sh dist-static/ovsresync /usr/local/bin/
CMD ["/usr/local/bin/launch-ovs.sh"]