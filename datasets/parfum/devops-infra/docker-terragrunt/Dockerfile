FROM ubuntu:jammy-20220531

# Which flavour of image to build
ARG SLIM=no
ARG AZURE=no
ARG AWS=no
ARG GCP=no

# Multi-architecture from buildx
ARG TARGETPLATFORM=linux/amd64

# Versions of dependecies, GCP has no default handler
ARG AWS_VERSION=latest
ARG GCP_VERSION
ARG TF_VERSION=latest
ARG TG_VERSION=latest

# List of Python packages
COPY pip/common/requirements.txt /tmp/pip_common_requirements.txt
COPY pip/aws/requirements.txt /tmp/pip_aws_requirements.txt
COPY pip/azure/requirements.txt /tmp/pip_azure_requirements.txt

# Install apt prerequisits
SHELL ["/bin/bash", "-euxo", "pipefail", "-c"]
# hadolint ignore=DL3008
RUN apt-get update -y ;\
  apt-get install --no-install-recommends -y \
    ca-certificates \
    curl \
    git \
    jq \
    unzip ;\
  if [ "${SLIM}" = "no" ]; then \
    apt-get install --no-install-recommends -y \
      bc \
      docker \
      graphviz \
      hub \
      make \
      ncurses-base \
      openssh-client \
      openssl \
      python3 \
      python3-pip \
      zip ;\
  fi ;\
  if [ "${AZURE}" = "yes" ]; then \
    apt-get install --no-install-recommends -y \
      gcc \
      libsodium-dev \
      python3-dev ;\
  fi ;\
  apt-get clean ;\
  rm -rf /var/lib/apt/lists/*

# Python packages
SHELL ["/bin/bash", "-euxo", "pipefail", "-c"]
# hadolint ignore=DL3013
RUN if [ "${SLIM}" = "no" ]; then \
    pip3 install --no-cache-dir -r /tmp/pip_common_requirements.txt ;\
  fi

# Get Terraform by a specific version or search for the latest one
SHELL ["/bin/bash", "-euxo", "pipefail", "-c"]
RUN if [ "${TARGETPLATFORM}" = "linux/amd64" ]; then ARCHITECTURE=amd64; elif [ "${TARGETPLATFORM}" = "linux/arm64" ]; then ARCHITECTURE=arm64; else ARCHITECTURE=amd64; fi ;\
  if [ "${TF_VERSION}" = "latest" ]; then \
    VERSION="$( curl -LsS https://releases.hashicorp.com/terraform/ | grep -Eo '/[.0-9]+/' | grep -Eo '[.0-9]+' | sort -V | tail -1 )" ;\
  else \
    VERSION="${TF_VERSION}" ;\
  fi ;\
  curl -LsS \
    https://releases.hashicorp.com/terraform/${VERSION}/terraform_${VERSION}_linux_${ARCHITECTURE}.zip -o ./terraform.zip ;\
  unzip ./terraform.zip ;\
  rm -f ./terraform.zip ;\
  chmod +x ./terraform ;\
  mv ./terraform /usr/bin/terraform

# Get Terragrunt by a specific version or search for the latest one
SHELL ["/bin/bash", "-euxo", "pipefail", "-c"]
RUN if [ "${TARGETPLATFORM}" = "linux/amd64" ]; then ARCHITECTURE=amd64; elif [ "${TARGETPLATFORM}" = "linux/arm64" ]; then ARCHITECTURE=arm64; else ARCHITECTURE=amd64; fi ;\
  if [ "${TG_VERSION}" = "latest" ]; then \
    VERSION="$( curl -LsS https://api.github.com/repos/gruntwork-io/terragrunt/releases/latest | jq -r .name )" ;\
  else \
    VERSION="v${TG_VERSION}" ;\
  fi ;\
  curl -LsS \
    https://github.com/gruntwork-io/terragrunt/releases/download/${VERSION}/terragrunt_linux_${ARCHITECTURE} -o /usr/bin/terragrunt ;\
  chmod +x /usr/bin/terragrunt

# Get latest TFLint
SHELL ["/bin/bash", "-euxo", "pipefail", "-c"]
RUN if [ "${TARGETPLATFORM}" = "linux/amd64" ]; then ARCHITECTURE=amd64; elif [ "${TARGETPLATFORM}" = "linux/arm64" ]; then ARCHITECTURE=arm64; else ARCHITECTURE=amd64; fi ;\
  DOWNLOAD_URL="$( curl -LsS https://api.github.com/repos/terraform-linters/tflint/releases/latest | grep -o -E "https://.+?_linux_${ARCHITECTURE}.zip" )" ;\
  curl -LsS "${DOWNLOAD_URL}" -o tflint.zip ;\
  unzip tflint.zip ;\
  rm -f tflint.zip ;\
  chmod +x tflint ;\
  mv tflint /usr/bin/tflint

# Get latest hcledit
SHELL ["/bin/bash", "-euxo", "pipefail", "-c"]
RUN if [ "${SLIM}" = "no" ]; then \
    if [ "${TARGETPLATFORM}" = "linux/amd64" ]; then ARCHITECTURE=amd64; elif [ "${TARGETPLATFORM}" = "linux/arm64" ]; then ARCHITECTURE=arm64; else ARCHITECTURE=amd64; fi ;\
    DOWNLOAD_URL="$( curl -LsS https://api.github.com/repos/minamijoyo/hcledit/releases/latest | grep -o -E "https://.+?_linux_${ARCHITECTURE}.tar.gz" )" ;\
    curl -LsS "${DOWNLOAD_URL}" -o hcledit.tar.gz ;\
    tar -xf hcledit.tar.gz ;\
    rm -f hcledit.tar.gz ;\
    chmod +x hcledit ;\
    chown "$(id -u):$(id -g)" hcledit ;\
    mv hcledit /usr/bin/hcledit ;\
  fi

# Get latest sops
SHELL ["/bin/bash", "-euxo", "pipefail", "-c"]
RUN if [ "${SLIM}" = "no" ]; then \
    if [ "${TARGETPLATFORM}" = "linux/amd64" ]; then ARCHITECTURE=amd64; elif [ "${TARGETPLATFORM}" = "linux/arm64" ]; then ARCHITECTURE=arm64; else ARCHITECTURE=amd64; fi ;\
    DOWNLOAD_URL="$( curl -LsS https://api.github.com/repos/mozilla/sops/releases/latest | grep -o -E "https://.+?\.linux.${ARCHITECTURE}" )" ;\
    curl -LsS "${DOWNLOAD_URL}" -o /usr/bin/sops ;\
    chmod +x /usr/bin/sops ;\
  fi

# Cloud CLIs
# AWS
SHELL ["/bin/bash", "-euxo", "pipefail", "-c"]
# hadolint ignore=DL3013
RUN if [ "${AWS}" = "yes" ]; then \
    xargs -n 1 -a /tmp/pip_aws_requirements.txt pip3 install --no-cache-dir ;\
    if [ "${TARGETPLATFORM}" = "linux/amd64" ]; then ARCHITECTURE=x86_64; elif [ "${TARGETPLATFORM}" = "linux/arm64" ]; then ARCHITECTURE=aarch64; else ARCHITECTURE=x86_64; fi ;\
    if [ "${AWS_VERSION}" = "latest" ]; then VERSION=""; else VERSION="-${AWS_VERSION}"; fi ;\
    curl -LsS "https://awscli.amazonaws.com/awscli-exe-linux-${ARCHITECTURE}${VERSION}.zip" -o /tmp/awscli.zip ;\
    mkdir -p /usr/local/awscli ;\
    unzip -q /tmp/awscli.zip -d /usr/local/awscli ;\
    /usr/local/awscli/aws/install ;\
  fi

# GCP
SHELL ["/bin/bash", "-euxo", "pipefail", "-c"]
# hadolint ignore=SC1091
RUN if [ "${GCP}" = "yes" ]; then \
    if [ "${TARGETPLATFORM}" = "linux/amd64" ]; then ARCHITECTURE=x86_64; elif [ "${TARGETPLATFORM}" = "linux/arm64" ]; then ARCHITECTURE=arm; else ARCHITECTURE=x86_64; fi ;\
    curl -LsS "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${GCP_VERSION}-linux-${ARCHITECTURE}.tar.gz" -o google-cloud-sdk.tar.gz ;\
    tar -xf google-cloud-sdk.tar.gz ;\
    rm -f google-cloud-sdk.tar.gz ;\
    ./google-cloud-sdk/install.sh \
      --usage-reporting false \
      --command-completion true \
      --path-update true \
      --quiet ;\
    /google-cloud-sdk/bin/gcloud config set component_manager/disable_update_check true ;\
    /google-cloud-sdk/bin/gcloud config set metrics/environment github_docker_image ;\
  fi

# Azure
SHELL ["/bin/bash", "-euxo", "pipefail", "-c"]
# hadolint ignore=DL3013
RUN if [ "${AZURE}" = "yes" ]; then \
    pip3 install --no-cache-dir --upgrade pip ;\
    SODIUM_INSTALL=system pip3 install --no-cache-dir -r /tmp/pip_azure_requirements.txt ;\
  fi

# Scripts, configs and cleanup
COPY fmt/format-hcl fmt/fmt.sh fmt/terragrunt-fmt.sh show-versions.sh /usr/bin/
SHELL ["/bin/bash", "-euxo", "pipefail", "-c"]
RUN chmod +x \
    /usr/bin/format-hcl \
    /usr/bin/fmt.sh \
    /usr/bin/terragrunt-fmt.sh \
    /usr/bin/show-versions.sh ;\
  # Cleanup
  rm -rf /var/cache/* ;\
  rm -rf /root/.cache/* ;\
  rm -rf /tmp/*

# Labels for http://label-schema.org/rc1/#build-time-labels
# And for https://github.com/opencontainers/image-spec/blob/master/annotations.md
# And for https://help.github.com/en/actions/building-actions/metadata-syntax-for-github-actions
ARG NAME="IaaC dockerized framework for Terraform/Terragrunt"
ARG DESCRIPTION="Docker image with Terraform v${TF_VERSION}, Terragrunt v${TG_VERSION} and all needed components to easily manage cloud infrastructure."
ARG REPO_URL="https://github.com/devops-infra/docker-terragrunt"
ARG AUTHOR="Krzysztof Szyper <biotyk@mail.com>"
ARG HOMEPAGE="https://christophshyper.github.io/"
ARG BUILD_DATE=2020-04-01T00:00:00Z
ARG VCS_REF=abcdef1
ARG VERSION="tf-${TF_VERSION}-tg-${TG_VERSION}"
LABEL \
  org.label-schema.build-date="${BUILD_DATE}" \
  org.label-schema.name="${NAME}" \
  org.label-schema.description="${DESCRIPTION}" \
  org.label-schema.usage="README.md" \
  org.label-schema.url="${HOMEPAGE}" \
  org.label-schema.vcs-url="${REPO_URL}" \
  org.label-schema.vcs-ref="${VCS_REF}" \
  org.label-schema.vendor="${AUTHOR}" \
  org.label-schema.version="${VERSION}" \
  org.label-schema.schema-version="1.0"	\
  org.opencontainers.image.created="${BUILD_DATE}" \
  org.opencontainers.image.authors="${AUTHOR}" \
  org.opencontainers.image.url="${HOMEPAGE}" \
  org.opencontainers.image.documentation="${REPO_URL}/blob/master/README.md" \
  org.opencontainers.image.source="${REPO_URL}" \
  org.opencontainers.image.version="${VERSION}" \
  org.opencontainers.image.revision="${VCS_REF}" \
  org.opencontainers.image.vendor="${AUTHOR}" \
  org.opencontainers.image.licenses="MIT" \
  org.opencontainers.image.title="${NAME}" \
  org.opencontainers.image.description="${DESCRIPTION}" \
  maintainer="${AUTHOR}" \
  repository="${REPO_URL}"

WORKDIR /data
CMD ["show-versions.sh"]
