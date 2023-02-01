# Copyright 2020 Google LLC
#
# Use of this source code is governed by an MIT-style
# license that can be found in the LICENSE file or at
# https://opensource.org/licenses/MIT.

FROM golang:1.14.1-buster

WORKDIR /

ARG HYDRA_VERSION=v1.7.4

# Install Hydra