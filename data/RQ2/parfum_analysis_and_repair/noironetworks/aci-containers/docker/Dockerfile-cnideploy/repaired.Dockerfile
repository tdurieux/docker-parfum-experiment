ARG basetag=latest
ARG baserepo=quay.io/noirolabs
FROM ${baserepo}/aci-containers-cnideploy-base:${basetag}
# Required OpenShift Labels
LABEL name="ACI CNI cnideploy" \
vendor="Cisco" \
version="v1.0.0" \
release="1" \
summary="This is an ACI CNI cnideploy." \
description="This operator will deploy a single instance of ACI CNI cnideploy."
# Required Licenses
COPY docker/licenses /licenses
COPY docker/launch-cnideploy.sh /usr/local/bin/
CMD ["/usr/local/bin/launch-cnideploy.sh"]