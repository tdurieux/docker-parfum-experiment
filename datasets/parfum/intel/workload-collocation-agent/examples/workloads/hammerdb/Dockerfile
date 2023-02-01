# Copyright (c) 2018 Intel Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


# Building HammerDB.
FROM centos:7 AS hammerdb

RUN yum update -y
RUN yum install -y wget

RUN wget https://download-ib01.fedoraproject.org/pub/epel/7/x86_64/Packages/p/proj-4.8.0-4.el7.x86_64.rpm
#rpm -Uvh proj-4.8.0-4.el7.x86_64.rpm
RUN yum install -y proj-4.8.0-4.el7.x86_64.rpm

RUN wget http://repo.mysql.com/mysql80-community-release-el7-3.noarch.rpm
RUN rpm -ivh mysql80-community-release-el7-3.noarch.rpm

# Required libmysqlclient.so.20 which is in old MySQL 5.7
RUN wget https://repo.mysql.com/yum/mysql-5.7-community/el/7/x86_64/mysql-community-libs-5.7.24-1.el7.x86_64.rpm
RUN yum install -y mysql-community-libs-5.7.24-1.el7.x86_64.rpm

RUN wget https://repo.mysql.com/yum/mysql-5.7-community/el/7/x86_64/mysql-community-client-5.7.24-1.el7.x86_64.rpm
RUN yum install -y mysql-community-client-5.7.24-1.el7.x86_64.rpm

RUN echo 'export LD_LIBRARY_PATH=/usr/lib64/mysql/' >> ~/.bashrc
# hadolint ignore=SC2039
RUN source ~/.bashrc

RUN wget -O /HammerDB-3.2.tar.gz https://sourceforge.net/projects/hammerdb/files/HammerDB/HammerDB-3.2/HammerDB-3.2-Linux.tar.gz/download
RUN tar -zxvf HammerDB-3.2.tar.gz

RUN rm proj-4.8.0-4.el7.x86_64.rpm \
    mysql80-community-release-el7-3.noarch.rpm \
    mysql-community-libs-5.7.24-1.el7.x86_64.rpm \
    HammerDB-3.2.tar.gz

WORKDIR /HammerDB-3.2
ENTRYPOINT ["./hammerdbcli auto"]
