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
    jq \
    python3.8 \
    python3-pip \
    unzip \
    sudo && rm -rf /var/lib/apt/lists/*;

##########################################
# Install python modules
##########################################
RUN pip install --no-cache-dir \
    awscli \
    docopt~=0.6 \
    schema~=0.7 \
    jmespath~=0.10 \
    s3transfer~=0.3 \
    parameterized~=0.7 \
    psutil~=5.8 \
    fbpcp==0.1.4

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

# Check that it's installed
RUN terraform --version

# Check that it's installed
RUN terraform --version

##########################################
# Copy deploy.sh and Terraform scripts
##########################################
RUN mkdir /terraform_deployment
COPY fbpcs/infra/publisher/deploy.sh /terraform_deployment
COPY fbpcs/infra/publisher/deploy-shared.sh /terraform_deployment
COPY fbpcs/infra/publisher/util.sh /terraform_deployment
RUN chmod +x /terraform_deployment/deploy.sh
RUN chmod +x /terraform_deployment/deploy-shared.sh
RUN chmod +x /terraform_deployment/util.sh
COPY fbpcs/infra/pce/aws_terraform_template /terraform_deployment/terraform_scripts
CMD ["/bin/bash"]
WORKDIR /terraform_deployment

##########################################
# Set onedocker env variables
##########################################
ENV PATH="/terraform_deployment:${PATH}"
ENV ONEDOCKER_REPOSITORY_PATH="LOCAL"
ENV ONEDOCKER_EXE_PATH="/terraform_deployment/"
