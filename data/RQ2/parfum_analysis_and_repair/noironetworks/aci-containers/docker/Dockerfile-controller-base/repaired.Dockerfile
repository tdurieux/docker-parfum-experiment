ARG basetag=latest
ARG baserepo=quay.io/noirolabs
FROM ${baserepo}/aci-containers-base:${basetag}
RUN curl -f -LO https://storage.googleapis.com/kubernetes-release/release/$( curl -f -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl \
  && chmod u+x kubectl && mv kubectl /usr/local/bin/kubectl \
  && curl -f -sL "https://github.com/istio/istio/releases/download/1.6.5/istioctl-1.6.5-linux-amd64.tar.gz" | tar xz \
  && chmod u+x istioctl && mv istioctl /usr/local/bin/istioctl \
  && mkdir -p /usr/local/var/lib/aci-cni
CMD ["/usr/bin/sh"]
