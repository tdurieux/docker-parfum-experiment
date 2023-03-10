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
RUN yum install -y epel-release && rm -rf /var/cache/yum
RUN yum install -y nginx && rm -rf /var/cache/yum
RUN yum install -y unzip && rm -rf /var/cache/yum

# Copy artifacts
RUN mkdir -p /home/admin/jifa-master/

COPY nginx.conf /home/admin/jifa-master/nginx.conf
COPY master.sh  /home/admin/jifa-master/master.sh
COPY jifa.tgz   /home/admin/jifa-master/jifa.tgz

# Make executable
RUN chmod -R a+x /home/admin/jifa-master/
EXPOSE 80

WORKDIR /home/admin/jifa-master/

# Setup entrypoint
ENTRYPOINT ["/home/admin/jifa-master/master.sh"]
