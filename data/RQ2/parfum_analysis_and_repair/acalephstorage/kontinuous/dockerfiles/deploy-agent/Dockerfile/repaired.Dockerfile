FROM debian:jessie
MAINTAINER admin@acale.ph

ENV KUBERNETES_VERSION 1.2.4

# install curl
# download kubectl
RUN apt-get update && \
    apt-get install --no-install-recommends -y curl && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    curl -f -O https://storage.googleapis.com/kubernetes-release/release/v${KUBERNETES_VERSION}/bin/linux/amd64/kubectl && \
    mv kubectl /usr/bin && \
    chmod +x /usr/bin/kubectl

ADD kube-config.yml /root/.kube/config
ADD run.sh /usr/bin/deploy-agent
RUN chmod +x /usr/bin/deploy-agent

ENTRYPOINT deploy-agent