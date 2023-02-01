# Copyright 2022 Harness Inc. All rights reserved.
# Use of this source code is governed by the PolyForm Free Trial 1.0.0 license
# that can be found in the licenses directory at the root of this repository, also available at
# https://polyformproject.org/wp-content/uploads/2020/05/PolyForm-Free-Trial-1.0.0.txt.

# CIE AGENT - PYTHON +BUILD TOOLS

# Usage: Used to run CIE builds for harness-core compilation, test
# Test image locally by running this command:
#
# $ docker build \
#     -f Dockerfile-python-cie-agent" \
#     -t <tag> \
#     .

FROM us.gcr.io/platform-205701/ubi/ubi-python:latest

USER root

RUN yum install -y jq \
    && yum clean all && rm -rf /var/cache/yum
RUN pip install --no-cache-dir urllib3 pygithub
