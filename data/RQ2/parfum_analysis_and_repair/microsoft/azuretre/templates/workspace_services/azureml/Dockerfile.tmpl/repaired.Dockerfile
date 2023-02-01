FROM debian:stretch-slim

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install Azure CLI
RUN apt-get update \
    && apt-get install --no-install-recommends -y ca-certificates="20200601~deb9u2" jq="1.5+dfsg-1.3" curl="7.52.1-5+deb9u16" apt-transport-https="1.4.11" lsb-release="9.20161125" gnupg="2.1.18-8~deb9u4" \
    && curl -f -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --batch --dearmor | tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null \
    && AZ_REPO=$(lsb_release -cs) \
    && echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | tee /etc/apt/sources.list.d/azure-cli.list \
    && apt-get update && apt-get -y --no-install-recommends install azure-cli="2.36.0-1~stretch" \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/*

RUN az extension add --name azure-firewall

ARG BUNDLE_DIR

# This is a template Dockerfile for the bundle's invocation image
# You can customize it to use different base images, install tools and copy configuration files.
#
# Porter will use it as a template and append lines to it for the mixins
# and to set the CMD appropriately for the CNAB specification.
#
# Add the following line to porter.yaml to instruct Porter to use this template
# dockerfile: Dockerfile.tmpl

# You can control where the mixin's Dockerfile lines are inserted into this file by moving "# PORTER_MIXINS" line
# another location in this file. If you remove that line, the mixins generated content is appended to this file.
# PORTER_MIXINS

# Use the BUNDLE_DIR build argument to copy files into the bundle

COPY . $BUNDLE_DIR
