ARG REGISTRY
FROM ${REGISTRY}/ubi8/ubi-minimal
RUN microdnf update && microdnf clean all
COPY aro e2e.test /usr/local/bin/
ENTRYPOINT ["aro"]
EXPOSE 2222/tcp 8080/tcp 8443/tcp 8444/tcp 8445/tcp
USER 1000