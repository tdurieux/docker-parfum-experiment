ARG basetag=latest
ARG baserepo=quay.io/noirolabs
FROM ${baserepo}/aci-containers-host-base:${basetag}
# Required OpenShift Labels
LABEL name="ACI CNI Host-Agent" \
vendor="Cisco" \
version="v1.0.0" \
release="1" \
summary="This is an ACI CNI Host-Agent." \
description="This will deploy a single instance of ACI CNI Host-Agent."
# Required Licenses
COPY docker/licenses /licenses
COPY dist-static/aci-containers-host-agent dist-static/opflex-agent-cni docker/launch-hostagent.sh docker/enable-hostacc.sh docker/enable-droplog.sh /usr/local/bin/
ENV TENANT=kube
ENV NODE_EPG='kubernetes|kube-nodes'
CMD ["/usr/local/bin/launch-hostagent.sh"]