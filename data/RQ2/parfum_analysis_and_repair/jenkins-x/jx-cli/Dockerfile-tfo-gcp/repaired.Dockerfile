FROM google/cloud-sdk:slim

ARG TARGETARCH
ARG TARGETOS
ARG VERSION


# unzip
RUN apt-get install --no-install-recommends -y unzip bash jq && \
    rm -rf /var/lib/apt/lists/*

# terraform
ENV TERRAFORM 0.14.6
RUN curl -f -LO https://releases.hashicorp.com/terraform/${TERRAFORM}/terraform_${TERRAFORM}_linux_amd64.zip && \
  unzip terraform_${TERRAFORM}_linux_amd64.zip && \
  chmod +x terraform && mv terraform /usr/bin && rm terraform_${TERRAFORM}_linux_amd64.zip

# yq
ENV YQ_VERSION "4.6.1"

RUN echo using yq version ${YQ_VERSION} and OS ${TARGETOS} arch ${TARGETARCH} && \
  curl -f -L -s https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_${TARGETOS}_${TARGETARCH} > yq && \
  chmod +x yq && mv yq /usr/bin

# jx
RUN echo using jx version ${VERSION} and OS ${TARGETOS} arch ${TARGETARCH} && \
  mkdir -p /home/.jx3 && \
  curl -f -L https://github.com/jenkins-x/jx-cli/releases/download/v${VERSION}/jx-cli-${TARGETOS}-${TARGETARCH}.tar.gz | tar xzv && \
  mv jx /usr/bin

# lets install the boot plugins
RUN jx upgrade plugins --boot --path /usr/bin

# lets install the admin plugin
RUN jx admin help

COPY run.sh /run.sh
ENTRYPOINT ["/bin/bash"]
CMD ["run.sh"]


LABEL org.opencontainers.image.source https://github.com/jenkins-x/jx-cli
