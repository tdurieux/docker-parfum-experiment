# Copyright 2016 The Kubernetes Authors All rights reserved.
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

FROM google/debian:wheezy

COPY cassandra.list /etc/apt/sources.list.d/cassandra.list

RUN gpg --batch --keyserver pgp.mit.edu --recv-keys F758CE318D77295D
RUN gpg --batch --export --armor F758CE318D77295D | apt-key add -

RUN gpg --batch --keyserver pgp.mit.edu --recv-keys 2B5C1B00
RUN gpg --batch --export --armor 2B5C1B00 | apt-key add -

RUN gpg --batch --keyserver pgp.mit.edu --recv-keys 0353B12C
RUN gpg --batch --export --armor 0353B12C | apt-key add -

RUN apt-get update && apt-get -qq --no-install-recommends -y install procps cassandra && rm -rf /var/lib/apt/lists/*;

COPY cassandra.yaml /etc/cassandra/cassandra.yaml
COPY logback.xml /etc/cassandra/logback.xml
COPY run.sh /run.sh
COPY kubernetes-cassandra.jar /kubernetes-cassandra.jar

RUN chmod a+rx /run.sh && \
    mkdir -p /cassandra_data/data && \
    chown -R cassandra.cassandra /etc/cassandra /cassandra_data && \
    chmod o+w -R /etc/cassandra /cassandra_data

VOLUME ["/cassandra_data/data"]   

USER cassandra

CMD /run.sh
