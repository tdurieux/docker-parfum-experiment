# Change FROM to arm64v8/python:3.8-alpine to test without the dependencies container
FROM dragonchain/dragonchain_core_dependencies:linux-arm64-latest

WORKDIR /usr/src/core
# Install necessary base dependencies and set UTC timezone for apscheduler
RUN apk --no-cache upgrade && apk --no-cache add libffi libstdc++ gmp && echo "UTC" > /etc/timezone

# Install dev build dependencies
RUN apk --no-cache add g++ make gmp-dev libffi-dev automake autoconf libtool
# Install python dev dependencies
ENV SECP_BUNDLED_EXPERIMENTAL 1
ENV SECP_BUNDLED_WITH_BIGNUM 1
COPY requirements.txt .
RUN python3 -m pip install --no-cache-dir -r requirements.txt
COPY dev_requirements.txt .
RUN python3 -m pip install --no-cache-dir --upgrade -r dev_requirements.txt

# Install Helm for chart linting and/or yq for doc builds if it doesn't exist
RUN if ! command -v helm; then \
    wget -O helm-v3.2.4-linux-arm64.tar.gz 'https://get.helm.sh/helm-v3.2.4-linux-arm64.tar.gz' && \
    tar xzf helm-v3.2.4-linux-arm64.tar.gz && mv linux-arm64/helm /usr/local/bin/helm && \
    rm -rf helm-v3.2.4-linux-arm64.tar.gz linux-arm64; fi && \
    if ! command -v yq; then \
    wget -O yq 'https://github.com/mikefarah/yq/releases/download/3.3.2/yq_linux_arm64' && \
    chmod +x yq && mv yq /usr/local/bin/; fi

# Copy our actual application