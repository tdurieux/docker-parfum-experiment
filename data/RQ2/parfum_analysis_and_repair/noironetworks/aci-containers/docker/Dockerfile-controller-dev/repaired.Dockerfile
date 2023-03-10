FROM noirolabs/ubibase:latest
RUN curl -f -LO https://storage.googleapis.com/kubernetes-release/release/$( curl -f -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
RUN chmod u+x kubectl && mv kubectl /usr/local/bin/kubectl
RUN curl -f -sL "https://github.com/istio/istio/releases/download/1.6.5/istioctl-1.6.5-linux-amd64.tar.gz" | tar xz
RUN chmod u+x istioctl && mv istioctl /usr/local/bin/istioctl
RUN mkdir -p /usr/local/var/lib/aci-cni
COPY pkg/istiocrd/upstream-istio-cr.yaml /usr/local/var/lib/aci-cni/upstream-istio-ctrlplane-resource.yaml
COPY dist-static/aci-containers-controller /usr/local/bin/
ENV AWS_SUBNETS="None"
ENV AWS_VPCID="None"
ENTRYPOINT exec /usr/local/bin/aci-containers-controller -config-path /usr/local/etc/aci-containers/controller.conf -aws-subnets $AWS_SUBNETS -vpc-id $AWS_VPCID
