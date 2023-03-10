# Copyright (c) 2021 Contributors to the Eclipse Foundation
#
# See the NOTICE file(s) distributed with this work for additional
# information regarding copyright ownership.
#
# This program and the accompanying materials are made available under the
# terms of the Eclipse Public License 2.0 which is available at
# http://www.eclipse.org/legal/epl-2.0
#
# SPDX-License-Identifier: EPL-2.0
#

# Base OS
FROM centos:latest

# Install dependencies
RUN yum install -y java-11-openjdk-devel && rm -rf /var/cache/yum
RUN yum install -y unzip && rm -rf /var/cache/yum

# Copy artifacts
RUN mkdir -p /home/admin/jifa-worker

COPY worker.sh  /home/admin/jifa-worker/worker.sh
COPY jifa.tgz   /home/admin/jifa-worker/jifa.tgz

# Make executable
RUN chmod -R a+x /home/admin/jifa-worker/
EXPOSE 8102

WORKDIR /home/admin/jifa-worker/

# Setup entrypoint
ENTRYPOINT ["/home/admin/jifa-worker/worker.sh"]
