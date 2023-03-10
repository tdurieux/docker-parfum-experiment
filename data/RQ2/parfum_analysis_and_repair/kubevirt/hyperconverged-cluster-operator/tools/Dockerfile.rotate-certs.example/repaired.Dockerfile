FROM centos:7

RUN yum install -y centos-release-openshift-origin311 && \
    yum install -y origin-clients && \
    yum clean all && \
    rm -rf /var/cache/yum

COPY rotate-certs.sh /usr/bin/

RUN chmod +x /usr/bin/rotate-certs.sh

ENTRYPOINT [ "/usr/bin/rotate-certs.sh" ]