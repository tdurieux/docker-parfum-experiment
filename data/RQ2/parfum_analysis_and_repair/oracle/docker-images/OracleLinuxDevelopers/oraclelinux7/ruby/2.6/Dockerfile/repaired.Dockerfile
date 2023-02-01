# Copyright (c) 2021 Oracle and/or its affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl.
FROM oraclelinux:7-slim

RUN yum -y install oracle-softwarecollection-release-el7 && \
    yum -y install rh-ruby26 \
                   rh-ruby26-ruby-devel \
                   rh-ruby26-rubygem-rake \
                   rh-ruby26-rubygem-bundler \
                   gcc make && \
    rm -rf /var/cache/yum

# Enable the SCL via environment modification