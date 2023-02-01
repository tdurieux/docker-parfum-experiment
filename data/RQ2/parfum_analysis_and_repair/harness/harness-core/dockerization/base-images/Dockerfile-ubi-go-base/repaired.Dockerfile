# Copyright 2022 Harness Inc. All rights reserved.
# Use of this source code is governed by the PolyForm Free Trial 1.0.0 license
# that can be found in the licenses directory at the root of this repository, also available at
# https://polyformproject.org/wp-content/uploads/2020/05/PolyForm-Free-Trial-1.0.0.txt.

# UBI BASE IMAGE + GO

# Usage: Application runtime base image for Go based application
# Test image locally by running this command:
#
# $ docker build \
#     -f Dockerfile-ubi-go-base" \
#     -t <tag> \
#     .

FROM us.gcr.io/platform-205701/ubi/ubi-base:latest

USER root

RUN curl -f -O https://dl.google.com/go/go1.18.linux-amd64.tar.gz \
    && tar -xvf go1.18.linux-amd64.tar.gz \
    && mv go/ /usr/local/ \
    && rm -rf go1.18.linux-amd64.tar.gz

ENV PATH ${PATH}:/opt/gsutil:/usr/local/go/bin

ENV GOROOT /usr/local/go
ENV GOPATH /usr/local

USER 65534