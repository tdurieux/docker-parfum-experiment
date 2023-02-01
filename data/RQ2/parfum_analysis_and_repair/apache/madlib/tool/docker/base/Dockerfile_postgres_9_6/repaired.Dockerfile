#
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

FROM postgres:9.6

### Get postgres specific add-ons
RUN apt-get update && apt-get install --no-install-recommends -y wget \
                       build-essential \
                       postgresql-server-dev-9.6 \
                       postgresql-plpython-9.6 \
                       openssl \
                       libssl-dev \
                       libboost-all-dev \
                       m4 \
                       wget \
                       vim \
                       pgxnclient \
                       flex \
                       bison \
                       graphviz && rm -rf /var/lib/apt/lists/*;

### Build custom CMake with SSQL support
RUN wget https://cmake.org/files/v3.6/cmake-3.6.1.tar.gz && \
      tar -zxvf cmake-3.6.1.tar.gz && \
      cd cmake-3.6.1 && \
      sed -i 's/-DCMAKE_BOOTSTRAP=1/-DCMAKE_BOOTSTRAP=1 -DCMAKE_USE_OPENSSL=ON/g' bootstrap && \
      ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && \
      make -j2 && \
      make install && rm cmake-3.6.1.tar.gz

### Install doxygen-1.8.13:
RUN wget https://ftp.stack.nl/pub/users/dimitri/doxygen-1.8.13.src.tar.gz && \
      tar xf doxygen-1.8.13.src.tar.gz && \
      cd doxygen-1.8.13 && \
      mkdir build && \
      cd build && \
      cmake -G "Unix Makefiles" .. && \
      make && \
      make install && rm doxygen-1.8.13.src.tar.gz

### Optional: install LaTex
### uncomment the following 'RUN apt-get' line to bake LaTex into the image
### Note: if you run the following line, please tag the image as
### madlib/postgres_9.6:LaTex, and don't tag it as latest
# RUN apt-get install -y texlive-full

## To build an image from this docker file without LaTex, from madlib folder, run:
## docker build -t madlib/postgres_9.6:latest -f tool/docker/base/Dockerfile_postgres_9_6 .
## To push it to docker hub, run:
## docker push madlib/postgres_9.6:latest

## To build an image from this docker file with LaTex, from madlib folder, uncomment
## line 60, and run:
## docker build -t madlib/postgres_9.6:LaTex -f tool/docker/base/Dockerfile_postgres_9_6 .
## To push it to docker hub, run:
## docker push madlib/postgres_9.6:LaTex