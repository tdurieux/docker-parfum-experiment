FROM centos:7

COPY ${RPMFILE} /tmp/

RUN yum --assumeyes install /tmp/${RPMFILE} && rm -rf /var/cache/yum

ENTRYPOINT ["/usr/bin/cypher-shell"]
