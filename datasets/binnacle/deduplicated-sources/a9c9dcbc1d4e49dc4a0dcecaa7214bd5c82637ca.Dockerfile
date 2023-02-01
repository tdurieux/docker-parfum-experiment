# Publihsed as splatform/stratos-ci-concourse

# Use:
# docker build -f Dockerfile.stratos-ci . -t splatform/stratos-ci-concourse:latest

# Default Image used to run tasks - contains Helm

# Builder for the github release tool
FROM splatform/stratos-go-build-base:opensuse as go-base
RUN export GOPATH=/home/stratos/go && \
    mkdir -p ${GOPATH} && \
    go get github.com/aktau/github-release


# CI Image
FROM opensuse/leap:latest

# Base tools
RUN zypper in -y curl tar git openssh wget gzip which jq

# Helm
RUN curl https://raw.githubusercontent.com/helm/helm/master/scripts/get > get_helm.sh && \
    chmod 700 get_helm.sh && \
    ./get_helm.sh

# GitHub Release tool
COPY --from=go-base /home/stratos/go/bin/github-release /usr/bin/github-release

# SSH configuration
RUN mkdir ~/.ssh && \
    touch ~/.ssh/config && \
    echo -e "Host github.com\n\tStrictHostKeyChecking no\n" >> ~/.ssh/config
