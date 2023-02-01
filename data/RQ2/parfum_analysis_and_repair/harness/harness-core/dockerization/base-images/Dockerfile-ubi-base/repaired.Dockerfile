# Copyright 2022 Harness Inc. All rights reserved.
# Use of this source code is governed by the PolyForm Free Trial 1.0.0 license
# that can be found in the licenses directory at the root of this repository, also available at
# https://polyformproject.org/wp-content/uploads/2020/05/PolyForm-Free-Trial-1.0.0.txt.

# BASE IMAGE - UBI

# Usage: Absolute base image for all images. Father of all!!
# Test image locally by running this command:
#
# $ docker build \
#     -f Dockerfile-ubi-base" \
#     -t <tag> \
#     .

FROM registry.access.redhat.com/ubi8/ubi:8.6-754
CMD ["/bin/sh"]
RUN yum -y update && yum -y install curl libstdc++.i686 make bash unzip hostname && rm -rf /var/cache/yum

##TODO:Latest version of yq is not supported, need to update logic for replace vars
RUN curl -f -L https://github.com/mikefarah/yq/releases/download/3.3.2/yq_linux_amd64 -o /usr/bin/yq && chmod +x /usr/bin/yq

#Disabling Subscription of RedHat
RUN sed -i 's/enabled=1/enabled=0/g' /etc/yum/pluginconf.d/subscription-manager.conf

RUN set -x \
    && mkdir -p /opt/harness/plugins \
    && mkdir -p /tmp \
    && chown -R 65534:65534 /opt/harness /tmp \
    && chmod -R 700 /opt/harness /tmp

WORKDIR /opt/harness

USER 65534