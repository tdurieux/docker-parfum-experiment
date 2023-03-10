ARG FROM=gcr.io/cloud-marketplace-tools/k8s/deployer_helm:latest
FROM $FROM

ONBUILD COPY chart /tmp/chart.tmp
 \
RUN cd /tmp \
        && mv chart.tmp/* chart \
        && tar -czvf /tmp/chart.tar.gz chart \
        && mkdir -p /data/chart \
        && mv chart.tar.gz /data/chart/ \
        && rm -Rf chart chart.tmp && rm /tmp/chart.tar.gzONBUILD






ONBUILD COPY schema.yaml /data/schema.yaml
# Provide registry prefix and tag for default values for images.
ONBUILD ARG REGISTRY
ONBUILD ARG TAG
ONBUILD RUN cat /data/schema.yaml \
        | env -i "REGISTRY=$REGISTRY" "TAG=$TAG" envsubst \
        > /data/schema.yaml.new \
        && mv /data/schema.yaml.new /data/schema.yaml
