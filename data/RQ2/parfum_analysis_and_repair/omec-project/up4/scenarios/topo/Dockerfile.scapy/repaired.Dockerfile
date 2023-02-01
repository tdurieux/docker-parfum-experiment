# SPDX-FileCopyrightText: 2020 Open Networking Foundation <info@opennetworking.org>
# SPDX-License-Identifier: Apache-2.0

FROM python:3.9.0-slim-buster
RUN apt-get update && apt-get install --no-install-recommends -y git net-tools tcpdump vim iputils-ping screen && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir ifcfg git+https://github.com/secdev/scapy
