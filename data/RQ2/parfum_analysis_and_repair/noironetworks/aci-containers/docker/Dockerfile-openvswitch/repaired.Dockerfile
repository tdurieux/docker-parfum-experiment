ARG basetag=latest
ARG baserepo=quay.io/noirolabs
FROM ${baserepo}/aci-containers-openvswitch-base:${basetag}
# Required OpenShift Labels
LABEL name="ACI CNI Openvswitch" \
vendor="Cisco" \
version="v1.0.0" \
release="1" \
summary="This is an ACI CNI Openvswitch." \
description="This will deploy a single instance of ACI CNI Openvswitch."
# Required Licenses
COPY docker/licenses /licenses
COPY docker/launch-ovs.sh docker/liveness-ovs.sh dist-static/ovsresync /usr/local/bin/
CMD ["/usr/local/bin/launch-ovs.sh"]