FROM ubuntu:20.04

ARG GO_VERSION="1.17.6" \
    TERRAFORM_VERSION="latest" \
    TERRAFORM_DOCS_VERSION="v0.16.0" \
    TFLINT_VERSION="v0.34.1" \
    TERRATEST_VERSION="v0.13.13" \
    KUBERNETES_VERSION="1.21.2"

ENV GOROOT=/usr/local/go \
    GOPATH=/go \
    PATH=/root/.tfenv/bin:${GOPATH}/bin:${GOROOT}/bin:${PATH} \
    LANGUAGE="C" \
    LC_ALL="C"

# Common
RUN apt-get update && apt-get install -y curl unzip git python3-pip

# Golang
RUN curl -sSL -o /tmp/go.tar.gz "https://golang.org/dl/go${GO_VERSION}.linux-amd64.tar.gz" \
 && tar -xzf /tmp/go.tar.gz -C /usr/local \
 && ${GOROOT}/bin/go install -v golang.org/x/tools/gopls@latest

# Terraform
RUN git clone https://github.com/tfutils/tfenv.git /root/.tfenv \
 && tfenv install ${TERRAFORM_VERSION} \
 && tfenv use $(ls /root/.tfenv/versions)

# Terraform-Docs
RUN curl -sSLo ./terraform-docs.tar.gz https://github.com/terraform-docs/terraform-docs/releases/download/${TERRAFORM_DOCS_VERSION}/terraform-docs-${TERRAFORM_DOCS_VERSION}-$(uname)-amd64.tar.gz \
 && tar -xzf terraform-docs.tar.gz -C /usr/bin/ terraform-docs \
 && rm terraform-docs.tar.gz 2> /dev/null

# Tflint
RUN curl -sSL "$(curl -s https://api.github.com/repos/terraform-linters/tflint/releases/latest | grep -o -E "https://.+?_linux_amd64.zip")" > tflint.zip \
 && unzip -qq tflint.zip tflint -d /usr/bin/ \
 && rm tflint.zip 2> /dev/null

# Terratest
RUN curl -sSL -o /usr/local/bin/terratest_log_parser "https://github.com/gruntwork-io/terratest/releases/download/${TERRATEST_VERSION}/terratest_log_parser_linux_amd64" \
 && chmod +x /usr/local/bin/terratest_log_parser

# Pre-Commit
RUN pip3 install -q --no-cache-dir pre-commit

# AWSCLI
RUN curl -sSL -o /tmp/awscliv2.zip "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" \
 && unzip /tmp/awscliv2.zip -d /tmp \
 && ./tmp/aws/install

# Kubectl
RUN curl -sSL -o /usr/bin/kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/${KUBERNETES_VERSION}/2021-07-05/bin/linux/amd64/kubectl \
 && chmod +x /usr/bin/kubectl \
 && curl -sS https://webinstall.dev/k9s | bash

# Dotfiles
COPY .aliases /root/.aliases
RUN echo "source /root/.aliases" >> /root/.bashrc

# Clean
RUN rm -rf /tmp/* && rm -rf /var/lib/apt/lists/*
