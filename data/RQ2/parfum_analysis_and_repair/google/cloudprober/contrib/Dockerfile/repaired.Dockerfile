# This Dockerfile packages contrib binaries alongwith cloudprober
# and ca certificates.
#
# Docker image built using this can executed in the following manner:
#   docker run -v $PWD/cloudprober.cfg:/etc/cloudprober.cfg \
#                         cloudprober/cloudprober
FROM busybox
ADD cloudprober /cloudprober
ADD bigquery_probe /contrib/bigquery_probe
COPY ca-certificates.crt /etc/ssl/certs/ca-certificates.crt

# Metadata params
ARG BUILD_DATE
ARG VERSION
ARG VCS_REF

# Metadata