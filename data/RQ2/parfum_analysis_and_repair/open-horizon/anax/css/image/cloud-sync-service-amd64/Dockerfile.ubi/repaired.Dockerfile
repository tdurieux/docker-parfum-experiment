FROM registry.access.redhat.com/ubi8/ubi-minimal:8.0

LABEL vendor="IBM"
LABEL summary="Object model storage and APIs in the management hub."
LABEL description="Provides the management hub side of the Model Management System, which stores object models and provides APIs for admins and edge nodes to access the object models."

# yum is not installed, use microdnf instead
# shadow-utils contains groupadd and adduser commands
RUN microdnf update -y --nodocs && microdnf clean all \
    && microdnf install --nodocs -y shadow-utils \
	&& groupadd -g 1000 cssuser && adduser -u 1000 -g cssuser cssuser \
    && microdnf install --nodocs -y openssl ca-certificates gettext \
    && microdnf clean all \
    && mkdir -p /licenses /var/edge-sync-service /etc/edge-sync-service /usr/edge-sync-service/bin \
    && chown -R cssuser:cssuser /var/edge-sync-service /etc/edge-sync-service /usr/edge-sync-service/bin

# create dirs and add license file
COPY LICENSE.txt /licenses

ADD cloud-sync-service /home/cssuser/cloud-sync-service

COPY config/sync.conf.tmpl /etc/edge-sync-service
COPY script/css_start.sh /usr/edge-sync-service/bin

USER cssuser

CMD ["/usr/edge-sync-service/bin/css_start.sh"]