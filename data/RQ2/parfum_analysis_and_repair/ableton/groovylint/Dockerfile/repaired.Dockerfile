# Copyright (c) 2019 Ableton AG, Berlin. All rights reserved.
#
# Use of this source code is governed by a MIT-style
# license that can be found in the LICENSE file.

FROM groovy:jre8

USER root

# For add-apt-repository
RUN apt-get update \
    && apt-get install -y software-properties-common=0.99.* --no-install-recommends \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Add deadsnakes and install Python 3.10