FROM amazon/aws-cli

ARG TARGETARCH
ARG TARGETOS
ARG VERSION

# install packages
RUN yum -y update \
    && yum install -y git tar gzip unzip jq which\
    && yum clean all && rm -rf /var/cache/yum

RUN curl -f -o aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.15.10/2020-02-22/bin/linux/amd64/aws-iam-authenticator && \
    chmod +x aws-iam-authenticator && \
    mv aws-iam-authenticator /usr/bin/aws-iam-authenticator

# terraform
ENV TERRAFORM 1.1.2
RUN curl -f -LO https://releases.hashicorp.com/terraform/${TERRAFORM}/terraform_${TERRAFORM}_linux_amd64.zip && \
  unzip terraform_${TERRAFORM}_linux_amd64.zip && \
  chmod +x terraform && mv terraform /usr/bin && rm terraform_${TERRAFORM}_linux_amd64.zip

# jx
RUN echo using jx version ${VERSION} and OS ${TARGETOS} arch ${TARGETARCH} && \
  mkdir -p /home/.jx3 && \
  curl -f -L https://github.com/jenkins-x/jx/releases/download/v${VERSION}/jx-${TARGETOS}-${TARGETARCH}.tar.gz | tar xzv && \
  mv jx /usr/bin

# lets install the boot plugins
RUN jx upgrade plugins --boot --path /usr/bin

# lets install the admin plugin
RUN jx admin help

COPY run.sh /run.sh
ENTRYPOINT ["/bin/bash"]
CMD ["/run.sh"]

LABEL org.opencontainers.image.source https://github.com/jenkins-x/jx
