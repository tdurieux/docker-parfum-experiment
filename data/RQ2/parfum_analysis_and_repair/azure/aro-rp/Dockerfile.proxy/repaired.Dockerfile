ARG REGISTRY
FROM ${REGISTRY}/ubi8/ubi-minimal
RUN microdnf update && microdnf clean all
COPY proxy /usr/local/bin
ENTRYPOINT ["proxy"]
EXPOSE 8443/tcp
USER 1000