# Copyright (c) Meta Platforms, Inc. and affiliates.
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.

ARG os_release="latest"

FROM ubuntu:${os_release}
ENV TZ=America/Los_Angeles
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

##########################################
# Install packages
##########################################
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    python3.8 \
    python3-dev \
    python3-pip \
    sudo \
    apt-transport-https \
    ca-certificates \
    gcc \
    gnupg \
    unzip && rm -rf /var/lib/apt/lists/*;

##########################################
# Install kubectl
##########################################
RUN sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
RUN sudo apt-get update && sudo apt-get install --no-install-recommends -y kubectl && rm -rf /var/lib/apt/lists/*;

##########################################
# Install gcloud SDK
##########################################
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list \
    && curl -f https://packages.cloud.google.com/apt/doc/apt-key.gpg | tee /usr/share/keyrings/cloud.google.gpg \
    && apt-get update -y && apt-get install --no-install-recommends google-cloud-sdk -y && rm -rf /var/lib/apt/lists/*;

##########################################
# Install pip packages
##########################################
RUN pip3 install --no-cache-dir fbpcp==0.2.6

##########################################
# Install Terraform
##########################################
ENV TERRAFORM_VERSION 0.14.9

# Download Terraform, verify checksum, and unzip
WORKDIR /usr/local/bin
RUN curl -f -SL https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip --output terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
  curl -f -SL https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_SHA256SUMS --output terraform_${TERRAFORM_VERSION}_SHA256SUMS && \
  grep terraform_${TERRAFORM_VERSION}_linux_amd64.zip terraform_${TERRAFORM_VERSION}_SHA256SUMS | sha256sum -c - && \
  unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
  rm terraform_${TERRAFORM_VERSION}_SHA256SUMS && \
  rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

##########################################
# Copy Terraform scripts
##########################################
RUN mkdir /terraform_deployment
COPY fbpcs/infra/pce/gcp_terraform_template /terraform_deployment/terraform_scripts
COPY fbpcs/infra/publisher/gcp/deploy.sh /terraform_deployment
COPY fbpcs/infra/publisher/gcp/util.sh /terraform_deployment
RUN chmod +x /terraform_deployment/deploy.sh
RUN chmod +x /terraform_deployment/util.sh
CMD ["/bin/bash"]
WORKDIR /terraform_deployment

##########################################
# Set onedocker env variables
##########################################
ENV PATH="/terraform_deployment:${PATH}"
ENV ONEDOCKER_REPOSITORY_PATH="LOCAL"
ENV ONEDOCKER_EXE_PATH="/terraform_deployment/"
