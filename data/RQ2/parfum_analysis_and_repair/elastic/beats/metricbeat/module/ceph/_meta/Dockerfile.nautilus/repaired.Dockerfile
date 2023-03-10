ARG CEPH_VERSION
FROM ceph/daemon:${CEPH_VERSION}

RUN yum -q install -y jq && yum clean all && rm -fr /var/cache/yum

# Wait for the health endpoint to have monitors information
ADD healthcheck.sh /
HEALTHCHECK --interval=1s --retries=300 CMD /healthcheck.sh

EXPOSE 5000 8003 9283

ENV NETWORK_AUTO_DETECT 4
ENV CEPH_DAEMON demo
ENV CEPH_DEMO_UID beats
ENV CEPH_DEMO_BUCKET beats
ENV CEPH_DEMO_ACCESS_KEY demo
ENV CEPH_DEMO_SECRET_KEY demo

CMD ["demo"]