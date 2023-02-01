# We need azurecli 2.37+ which doesn't exist for strech so the minimum is buster
FROM debian:buster-slim

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

# Install jq
RUN apt-get update && apt-get install --no-install-recommends -y jq="1.5+dfsg-2+b1" && apt-get clean -y && rm -rf /var/lib/apt/lists/*
