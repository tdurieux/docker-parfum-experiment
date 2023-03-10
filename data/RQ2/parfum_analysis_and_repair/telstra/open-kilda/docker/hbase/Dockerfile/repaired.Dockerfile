# Copyright 2017 Telstra Open Source
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#

ARG base_image=kilda/base-ubuntu
FROM ${base_image}

ENV PACKAGE hbase-1.2.4

WORKDIR /tmp/

RUN wget -q https://archive.apache.org/dist/hbase/1.2.4/${PACKAGE}-bin.tar.gz \
    && wget -q https://archive.apache.org/dist/hbase/1.2.4/${PACKAGE}-bin.tar.gz.md5 \
    && sed 's/\ //g' ${PACKAGE}-bin.tar.gz.md5 > $PACKAGE.tmp.md5 \
    && awk -F ":" '{print $2 " " $1}' $PACKAGE.tmp.md5 > ${PACKAGE}-bin.tar.gz.md5 \
    && md5sum -c ${PACKAGE}-bin.tar.gz.md5 \
    && tar -xzf ${PACKAGE}-bin.tar.gz --directory /opt/ \
    && ln -s /opt/$PACKAGE /opt/hbase \
    && rm -rfv /tmp/* && rm ${PACKAGE}-bin.tar.gz

WORKDIR /opt/hbase/

COPY hbase-conf/hbase-env.sh hbase-conf/hbase-site.xml /opt/hbase/conf/
COPY hbase-conf/start-hbase /opt/hbase/bin/start-hbase
