ARG basetag=latest
ARG baserepo=quay.io/noirolabs
FROM ${baserepo}/aci-containers-base:${basetag}
COPY dist-static/gbpserver /usr/local/bin/
# Required OpenShift Labels
LABEL name="ACI CNI gbpserver" \
vendor="Cisco" \
version="v1.0.0" \
release="1" \
summary="This is an ACI controller init." \
description="This will execute the binary in batch mode"
# Required Licenses
COPY docker/licenses /licenses