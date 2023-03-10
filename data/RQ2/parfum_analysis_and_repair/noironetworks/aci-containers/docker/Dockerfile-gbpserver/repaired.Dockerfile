ARG basetag=latest
ARG baserepo=quay.io/noirolabs
FROM ${baserepo}/aci-containers-base:${basetag}
COPY dist-static/gbpserver /usr/local/bin/
# Required OpenShift Labels
LABEL name="ACI CNI gbpserver" \
vendor="Cisco" \
version="v1.0.0" \
release="1" \
summary="This is an ACI CNI gbpserver." \
description="This will deploy a single instance of ACI CNI gbpserver."
# Required Licenses
COPY docker/licenses /licenses
ENV GBP_SERVER_CONF=None
ENTRYPOINT exec /usr/local/bin/gbpserver -proxy-listen-port 443 --config-path $GBP_SERVER_CONF