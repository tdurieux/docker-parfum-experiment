# Copyright 2017-2022 AVSystem <avsystem@avsystem.com>
# AVSystem Anjay LwM2M SDK
# All rights reserved.
#
# Licensed under the AVSystem-5-clause License.
# See the attached LICENSE file for details.


FROM ubuntu:20.04

WORKDIR /Anjay

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -yq git build-essential cmake libmbedtls-dev zlib1g-dev && rm -rf /var/lib/apt/lists/*;

COPY . .

RUN cmake .
RUN make -j

ENV HOME /Anjay

