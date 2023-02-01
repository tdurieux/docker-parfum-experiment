FROM ipfs/ipfs-cluster-test:v1.0.1

ENV CLUSTER_IPFSPROXY_LISTENMULTIADDRESS=/ip4/0.0.0.0/tcp/9095

COPY ./start-daemons.sh /usr/local/bin/fula-start-daemons.sh

ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/fula-start-daemons.sh"]

# Defaults for ipfs-cluster-service go here
CMD ["daemon"]