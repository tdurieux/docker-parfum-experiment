FROM centos:centos7
LABEL description="/virtual-node"

COPY ./bin/virtual-node virtual-node
ENTRYPOINT ["/virtual-node"]