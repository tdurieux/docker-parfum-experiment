#
# Copyright 2020-present, Nuance, Inc. and its contributors.
# All rights reserved.
#
# This source code is licensed under the Apache Version 2.0 license found in 
# the LICENSE.md file in the root directory of this source tree.
#

# Docker file for creating a Janus gateway build image.

FROM ubuntu:20.04

# Specify the tool for creating and managing the images
ARG IMAGE_TOOL=external

# Specify the commit tag version
ARG CI_COMMIT_TAG=none

# Add the scripts
ADD scripts/setup.sh scripts/build.sh scripts/start.sh scripts/Dockerfile.exec /image/

# Add janus configuration
ADD janus_config /image/janus_config

# First we need to add all the tools and components
RUN image/setup.sh

# Commented out for convenience