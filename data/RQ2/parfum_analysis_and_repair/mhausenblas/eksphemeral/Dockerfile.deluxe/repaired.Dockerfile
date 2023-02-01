FROM amazonlinux:2018.03
MAINTAINER hausenbl@amazon.com

# install eksctl, IAM authenticator, kubectl, and Helm
RUN yum -y install shadow-utils && \
    curl -f -o aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.12.7/2019-03-27/bin/linux/amd64/aws-iam-authenticator && \
    chmod +x ./aws-iam-authenticator && \
    mv ./aws-iam-authenticator /usr/local/bin && \
    curl -f --silent --location "https://github.com/weaveworks/eksctl/releases/download/0.1.38/eksctl_Linux_amd64.tar.gz" | tar xz -C /tmp && \
    mv -v /tmp/eksctl /usr/local/bin && \
    curl -f -LO https://storage.googleapis.com/kubernetes-release/release/$( curl -f -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/local/bin && \
    curl -f https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get > get_helm.sh && \
    chmod +x get_helm.sh && \
    ./get_helm.sh && \
    JQ=/usr/bin/jq && \
    curl -f https://stedolan.github.io/jq/download/linux64/jq > $JQ && chmod +x $JQ && rm -rf /var/cache/yum

WORKDIR /

RUN /usr/sbin/useradd eksctl

USER eksctl

COPY deluxe-install.sh .

CMD ./deluxe-install.sh