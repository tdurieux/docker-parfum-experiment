FROM registry.access.redhat.com/ubi8/ubi-minimal:8.0

LABEL vendor="IBM"
LABEL summary="Edge node Model Management System."
LABEL description="Provides the edge node side of the Model Management System to be used by the CLI service test tools when also testing object models."

# yum is not installed, use microdnf instead
RUN microdnf update -y --nodocs && microdnf clean all \
	&& microdnf install -y --nodocs openssl ca-certificates \
	&& microdnf clean all \
	&& mkdir -p /licenses

# add license file
COPY LICENSE.txt /licenses

ADD edge-sync-service /edge-sync-service/

CMD ["/edge-sync-service/edge-sync-service"]