FROM alpine:3.8

RUN apk add --no-cache --update \
    bash \
    coreutils \
    findutils \
    make \
    go=1.10.8-r0 \
    python=2.7.15-r1 \
    python3 \
    py-pip=10.0.1-r0 \
    grep \
    git \
    perl

RUN pip install --no-cache-dir flake8 jinja2

RUN wget https://shellcheck.storage.googleapis.com/shellcheck-v0.6.0.linux.x86_64.tar.xz && \
    tar -xf shellcheck-v0.6.0.linux.x86_64.tar.xz && \
    mv shellcheck-v0.6.0/shellcheck /usr/local/bin/ && \
    rm -r shellcheck-v0.6.0 shellcheck-v0.6.0.linux.x86_64.tar.xz
ARG BUILD_TERRAFORM_VERSION
ENV TERRAFORM_VERSION="${BUILD_TERRAFORM_VERSION}"

RUN wget "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    mv terraform /usr/local/bin/

RUN wget https://github.com/hadolint/hadolint/releases/download/v1.15.0/hadolint-Linux-x86_64 && \
    chmod +x hadolint-Linux-x86_64 && \
    mv hadolint-Linux-x86_64 /usr/local/bin/hadolint

RUN wget https://github.com/segmentio/terraform-docs/releases/download/v0.6.0/terraform-docs-v0.6.0-linux-amd64 && \
    mv terraform-docs* /usr/local/bin/terraform-docs && \
    chmod 0755 /usr/local/bin/terraform-docs

RUN wget https://raw.githubusercontent.com/antonbabenko/pre-commit-terraform/master/terraform_docs.sh && \
    mv terraform_docs.sh /usr/local/bin/terraform_docs.sh && \
    chmod 0755 /usr/local/bin/terraform_docs.sh

ARG BUILD_PROVIDER_GSUITE_VERSION
ENV PROVIDER_GSUITE_VERSION="${BUILD_PROVIDER_GSUITE_VERSION}"

RUN wget "https://github.com/DeviaVir/terraform-provider-gsuite/releases/download/v${PROVIDER_GSUITE_VERSION}/terraform-provider-gsuite_${PROVIDER_GSUITE_VERSION}_linux_amd64.tgz" && \
    tar xzf terraform-provider-gsuite_${PROVIDER_GSUITE_VERSION}_linux_amd64.tgz && \
    rm terraform-provider-gsuite_${PROVIDER_GSUITE_VERSION}_linux_amd64.tgz && \
    install -m 0755 -d ~/.terraform.d/plugins/ && \
    mv terraform-provider-gsuite_v${PROVIDER_GSUITE_VERSION} ~/.terraform.d/plugins/
