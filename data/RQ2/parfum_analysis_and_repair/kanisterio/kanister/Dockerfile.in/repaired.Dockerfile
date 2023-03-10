ARG base_image=registry.access.redhat.com/ubi8/ubi-minimal:8.6-854
FROM ${base_image}
ARG kanister_version

LABEL name=ARG_BIN \
      vendor="Kanister" \
      version="${kanister_version}" \
      release="${kanister_version}" \
      summary="Microservice for application-specific data management" \
      maintainer="Tom Manville<tom@kasten.io>" \
      description="Frameworks and utilities for application-specific data management, has updated openssl-libs."

RUN microdnf update openssl-libs && \
    microdnf update cyrus-sasl-lib && \
    microdnf install git && \
    microdnf clean all

COPY licenses /licenses/licenses

ADD ARG_SOURCE_BIN /ARG_BIN
ENTRYPOINT ["/ARG_BIN"]