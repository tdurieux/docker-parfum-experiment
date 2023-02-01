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


FROM cassandra:3.11

# library tzdata start interactive dialog, in docker this must be turned off
ENV DEBIAN_FRONTEND=noninteractive

RUN ln -sfn /usr/bin/python2 /usr/bin/python
RUN apt-get update && \
    apt-get --no-install-recommends -y install build-essential=12.4ubuntu1 \
    libssl-dev=1.1.1-1ubuntu2.1~18.04.5 zlib1g-dev=1:1.2.11.dfsg-0ubuntu2 \
    libncurses5-dev=6.1-1ubuntu1.18.04 libncursesw5-dev=6.1-1ubuntu1.18.04 \
    libreadline-dev=7.0-3 libsqlite3-dev=3.22.0-1ubuntu0.3 \
    libgdbm-dev=1.14.1-6 libdb5.3-dev=5.3.28-13.1ubuntu1.1 \
    libbz2-dev=1.0.6-8.1ubuntu0.2 libexpat1-dev=2.2.5-3ubuntu0.2 \
    liblzma-dev=5.2.2-1.3 tk-dev=8.6.0+9 wget=1.19.4-1ubuntu2.2 \
    netcat=1.10-41.1 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
RUN wget https://www.python.org/ftp/python/3.6.6/Python-3.6.6.tar.xz
RUN tar xf Python-3.6.6.tar.xz
WORKDIR /Python-3.6.6
RUN ./configure --enable-optimizations
RUN make -j 8
RUN make altinstall
WORKDIR /
RUN mkdir -p /stress
