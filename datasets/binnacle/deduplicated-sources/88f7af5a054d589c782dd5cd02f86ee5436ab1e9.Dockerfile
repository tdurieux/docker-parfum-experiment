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

MAINTAINER elodina

#Get and build
RUN go get github.com/tools/godep
RUN mkdir -p $GOPATH/src/github.com/elodina/ && cd $GOPATH/src/github.com/elodina && git clone https://github.com/elodina/syslog-kafka.git && cd syslog-kafka && godep restore
RUN cd $GOPATH/src/github.com/elodina/syslog-kafka && go build

RUN cp $GOPATH/src/github.com/elodina/syslog-kafka/syslog-kafka /usr/bin/syslog-kafka

ENTRYPOINT ["syslog-kafka"]