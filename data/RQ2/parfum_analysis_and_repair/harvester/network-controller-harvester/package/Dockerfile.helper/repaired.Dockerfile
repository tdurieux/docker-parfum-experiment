FROM registry.suse.com/bci/bci-minimal:15.3
COPY bin/harvester-network-helper /usr/bin/
CMD ["harvester-network-helper"]