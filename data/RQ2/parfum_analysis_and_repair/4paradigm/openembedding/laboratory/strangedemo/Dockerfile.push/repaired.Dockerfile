FROM ubuntu:18.04
RUN apt-get update && apt-get install --no-install-recommends -y vim apt-transport-https ca-certificates curl gnupg-agent software-properties-common wget && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sSL https://get.daocloud.io/docker | sh
RUN wget https://mirror.azure.cn/kubernetes/helm/helm-v2.14.1-linux-amd64.tar.gz && \
    tar -xzf helm-v2.14.1-linux-amd64.tar.gz && cp linux-amd64/helm linux-amd64/tiller /usr/local/bin && \
    rm -rf linux-amd64 helm-v2.14.1-linux-amd64.tar.gz
