FROM alpine:3.12.3
RUN apk upgrade --no-cache && \
    apk update && apk add --no-cache curl && \
    curl -f -LO https://storage.googleapis.com/kubernetes-release/release/$( curl -f -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \
    chmod u+x kubectl && mv kubectl /usr/local/bin/kubectl && \
    curl -f -LO https://istio.io/operator.yaml && \
    mkdir -p /usr/local/var/lib/aci-cni
COPY pkg/istiocrd/upstream-istio-cr.yaml /usr/local/var/lib/aci-cni/upstream-istio-ctrlplane-resource.yaml
COPY dist-static/aci-containers-controller /usr/local/bin/
ENV AWS_SUBNETS="None"
ENV AWS_VPCID="None"
ENTRYPOINT exec /usr/local/bin/aci-containers-controller -config-path /usr/local/etc/aci-containers/controller.conf -aws-subnets $AWS_SUBNETS -vpc-id $AWS_VPCID
