#
# Copyright 2020-present, Nuance, Inc. and its contributors.
# All rights reserved.
#
# This source code is licensed under the Apache Version 2.0 license found in
# the LICENSE.md file in the root directory of this source tree.
#

# Docker file for creating a Janus gateway target image.

FROM ubuntu:20.04

ARG CI_COMMIT_TAG=none

# API secure ports only
EXPOSE 8089/tcp 7889/tcp

# First we need to add all the tools and components
RUN apt update && DEBIAN_FRONTEND="noninteractive" apt --no-install-recommends install -y libconfig-dev libjansson-dev libcurl4-openssl-dev libmicrohttpd-dev && rm -rf /var/lib/apt/lists/*;

# Other libraries that may be necessary for the execution depending on the enabled features
# libssl-dev libsofia-sip-ua-dev libglib2.0-dev libopus-dev libogg-dev liblua5.3-dev libconfig-dev gengetopt libavutil-dev libavcodec-dev libavformat-dev

ADD ./root/ /

ENTRYPOINT ["/start.sh"]
