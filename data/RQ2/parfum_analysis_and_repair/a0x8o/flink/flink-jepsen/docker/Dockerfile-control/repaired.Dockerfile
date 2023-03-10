################################################################################
#  Licensed to the Apache Software Foundation (ASF) under one
#  or more contributor license agreements.  See the NOTICE file
#  distributed with this work for additional information
#  regarding copyright ownership.  The ASF licenses this file
#  to you under the Apache License, Version 2.0 (the
#  "License"); you may not use this file except in compliance
#  with the License.  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
# limitations under the License.
################################################################################

FROM debian:stretch

RUN apt-get update && \
    apt-get install --no-install-recommends -qqy \
            less \
            libjna-java \
            gnuplot \
            openjdk-8-jdk \
            openssh-client \
            vim \
            wget && rm -rf /var/lib/apt/lists/*;

ENV LEIN_ROOT true
RUN wget https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein && \
    mv lein /usr/bin && \
    chmod +x /usr/bin/lein && \
    lein self-install

ADD id_rsa /root/.ssh/
ADD id_rsa.pub /root/.ssh/
RUN touch ~/.ssh/known_hosts

WORKDIR /jepsen

CMD tail -f /dev/null
