# Copyright (c) 2021 LG Electronics Inc.
# SPDX-License-Identifier: Apache-2.0
FROM	ubuntu:20.04

RUN apt-get update && apt-get install --no-install-recommends sudo -y && rm -rf /var/lib/apt/lists/*;
RUN	ln -sf /bin/bash /bin/sh

COPY	. /app
WORKDIR	/app

ENV 	DEBIAN_FRONTEND=noninteractive

RUN apt-get -y --no-install-recommends install build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install python3 python3-distutils python3-pip python3-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install python3-intbitset python3-magic && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libxml2-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libxslt1-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libhdf5-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install bzip2 xz-utils zlib1g libpopt0 && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install gcc-10 g++-10 && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir .
RUN pip3 install --no-cache-dir dparse

ENTRYPOINT ["/usr/local/bin/fosslight_source"]
