# Copyright 2022 Harness Inc. All rights reserved.
# Use of this source code is governed by the PolyForm Free Trial 1.0.0 license
# that can be found in the licenses directory at the root of this repository, also available at
# https://polyformproject.org/wp-content/uploads/2020/05/PolyForm-Free-Trial-1.0.0.txt.

# CIE AGENT - DOCKER BUILD

# Usage: Used to run docker build for applications
# Test image locally by running this command:
#
# $ docker build \
#     -f Dockerfile-docker-build-cie-agent" \
#     -t <tag> \
#     .

FROM us.gcr.io/platform-205701/ubi/ubi-java:latest

USER root

RUN yum install -y yum-utils && yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo \
    && yum install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin && rm -rf /var/cache/yum