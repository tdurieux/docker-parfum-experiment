# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

############################################################
# Dockerfile to build Traffic Ops DB admin test environment
############################################################

FROM centos:7
ARG POSTGRES_VERSION=13.2
ENV POSTGRES_VERSION=$POSTGRES_VERSION

RUN yum install -y \
		epel-release \
		centos-release-scl-rh \
		https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm \
    git && \
    yum -y install           \
        cpanminus            \
        expat-devel          \
        libcap               \
        libcurl-devel        \
        libidn-devel         \
        libpcap-devel        \
        mkisofs              \
        openssl-devel        \
        perl-core            \
        perl-Crypt-ScryptKDF \
        perl-DBD-Pg          \
        perl-DBI             \
        perl-Digest-SHA1     \
        perl-JSON            \
        perl-libwww-perl     \
        perl-TermReadKey     \
        perl-Test-CPAN-Meta  \
        perl-WWW-Curl        \
        postgresql13         \
        postgresql13-devel && \
    yum clean all && rm -rf /var/cache/yum

# Override TRAFFIC_OPS_RPM arg to use a different one using --build-arg TRAFFIC_OPS_RPM=...  Can be local file or http://...
ARG TRAFFIC_OPS_RPM=traffic_ops.rpm
ADD $TRAFFIC_OPS_RPM /
RUN rpm -Uvh $(basename $TRAFFIC_OPS_RPM) && \
    rm $(basename $TRAFFIC_OPS_RPM)

WORKDIR /opt/traffic_ops/app

COPY run-db-test.sh \
    db-config.sh \
    /

COPY initdb.d/ /db_dumps/

CMD /run-db-test.sh
