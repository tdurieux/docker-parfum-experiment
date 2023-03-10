# Copyright Amazon.com Inc. or its affiliates. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


# *NOTE* we have to limit our number of layers heres because in presubmits there
# is no overlay fs and we will run out of space quickly

################# BUILDER #####################
ARG BASE_IMAGE
ARG BUILDER_IMAGE
ARG BUILT_BUILDER_IMAGE
FROM ${BUILDER_IMAGE} as builder

# Copy scripts in every variant since we do not rebuild the base
# every time these scripts change. This ensures whenever a variant is
# built it has the latest scripts in the builder
COPY scripts/ /usr/bin

RUN set -x && \
    # manually "install" systemd to avoid installing the entire dep tree
    clean_install systemd true true && \
    # following are from coreutils needed by install scriptlets
    for cmd in "readlink" "rm"; do cp /usr/bin/$cmd $NEWROOT/usr/bin/; done && \
    clean_install "ebtables ipset iptables iptables-nft kmod" && \
    # al2022 does not have this package yet.  it may not actually be needed but is included in upstrea
    # kube-proxy base image
    install_if_al2 conntrack-tools && \
    install_if_al2022 iptables-legacy && \
    for cmd in "readlink" "rm"; do rm $NEWROOT/usr/bin/$cmd; done && \
    # remove bash + systemd and deps
    remove_package systemd true && \
    remove_package bash && \
    # Remove bad symlinks due to deleted man files
    find $NEWROOT/etc/alternatives -xtype l -name "*-man" -delete -print && \
    cleanup "iptables"


# AL2 doesn't setup the ip6tables alternative the same as ubuntu/debian
# which is what the iptables-wrapper script provided by kubernetes expects
# since kind's entrypoint assumes this adding the alternative
# adding the alternative for ip6tabels here so the --set calls would work later on as expected
# https://github.com/kubernetes/release/blob/master/images/build/debian-iptables/buster/iptables-wrapper