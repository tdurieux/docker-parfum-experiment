# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM golang:1.4

MAINTAINER stealthly

#Get and build
RUN git clone https://github.com/pote/gpm.git && cd gpm && git checkout v1.3.1 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make install
RUN go get github.com/stealthly/go_kafka_client && cd $GOPATH/src/github.com/stealthly/go_kafka_client && gpm install
RUN cd $GOPATH/src/github.com/stealthly/go_kafka_client/syslog && go build

RUN cp $GOPATH/src/github.com/stealthly/go_kafka_client/syslog/syslog /usr/bin/syslogproducer

ENTRYPOINT ["syslogproducer"]