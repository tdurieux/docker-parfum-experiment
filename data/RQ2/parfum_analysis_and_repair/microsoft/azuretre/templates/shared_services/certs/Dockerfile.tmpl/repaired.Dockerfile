FROM python:3.8-slim-buster

ARG BUNDLE_DIR

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install Azure CLI
# It's useless to specify azcli version since the mixin installs the latest anyway
# hadolint ignore=DL3008
RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates="20200601~deb10u2" jq="1.5+dfsg-2+b1" curl="7.64.0-4+deb10u2" apt-transport-https="1.8.2.3" lsb-release="10.2019051400" gnupg="2.2.12-1+deb10u2" \
    && curl -f -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --batch --dearmor | tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null \
    && AZ_REPO=$(lsb_release -cs) \
    && echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | tee /etc/apt/sources.list.d/azure-cli.list \
    && apt-get update && apt-get -y --no-install-recommends install azure-cli \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# Install Certbot
# Some of the tools' versions seem to depend on the base image so proboably best not to specify them.
# hadolint ignore=DL3008
RUN apt-get update \
    && apt-get install -y --no-install-recommends python3 python3-venv libaugeas0="1.11.0-3" \
    && python3 -m venv /opt/certbot/ \
    && /opt/certbot/bin/pip install --no-cache-dir --upgrade pip \
    && /opt/certbot/bin/pip install --no-cache-dir certbot \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# Use the BUNDLE_DIR build argument to copy files into the bundle
COPY . $BUNDLE_DIR
