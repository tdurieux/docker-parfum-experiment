#################################################
# SmartIDE Developer Container Image
# Licensed under GPL v3.0
# Copyright (C) leansoftX.com
#################################################

FROM registry.cn-hangzhou.aliyuncs.com/smartide/smartide-node-v2:latest

USER root

# install cpp sdk
RUN apt-get update && \
    apt-get install --no-install-recommends -y build-essential cmake clang libssl-dev && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && \
    apt-get install --no-install-recommends -y libcurl4-openssl-dev libssl-dev uuid-dev zlib1g-dev libpulse-dev && rm -rf /var/lib/apt/lists/*;

