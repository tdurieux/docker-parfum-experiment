FROM ubuntu:16.04
RUN apt-get update && \
    apt-get install --no-install-recommends -y openvswitch-common openvswitch-switch \
									bridge-utils traceroute tcpdump && rm -rf /var/lib/apt/lists/*;

# This is based on stackanetes-entrypoint to provide a drop in replacement
# for the stackanetes openvswitch containers
#
# However, this should be removed when we transition to all init-containers
# in openstack-helm
COPY kubernetes-entrypoint /
CMD ["/kubernetes-entrypoint"]
