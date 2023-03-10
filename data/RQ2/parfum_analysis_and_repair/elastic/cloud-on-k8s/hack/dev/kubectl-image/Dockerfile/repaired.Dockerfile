FROM centos:8

RUN yum -y update && yum -y install nc && rm -rf /var/cache/yum

ENV KUBECTL_VERSION 1.14.7
RUN curl -f -sSL https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl \
    > /usr/local/bin/kubectl && chmod +x /usr/local/bin/kubectl
