ARG CEPH_VERSION
FROM ceph/daemon:${CEPH_VERSION}

RUN yum -q install -y jq && yum clean all && rm -fr /var/cache/yum

# Wait for the health endpoint to have monitors information
HEALTHCHECK --interval=1s --retries=300 \
  CMD curl -s -H "Accept: application/json" localhost:5000/api/v0.1/health \
        | jq .output.health.health_services[0].mons[0] \
        | grep health

ENV NETWORK_AUTO_DETECT 4
ENV DEMO_DAEMONS osd,rest_api

CMD ["demo"]