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
#

# Downloads and installs apache proton and qpid dispatch on the latest version of Fedora and starts the dispatch router
# /main is the top level folder under which proton (/main/qpid-proton/) and dispatch (/main/qpid-dispatch) source code is downloaded from github
# /usr/lib64 is the folder in which the proton artifacts are installed.
# /usr/sbin is the folder in which dispatch executable installed
# Copy this docker file to your local folder. Build the docker file like this - sudo docker build -t <username>/dispatch --file=Dockerfile-fedora . (don't miss the dot at the end)
# To run it - sudo docker run -i -t <username>/dispatch (this will launch the dispatch router)

# Gets the latest Fedora from dockerhub
FROM fedora:latest

MAINTAINER "dev@qpid.apache.org"

# Install required packages. Some in this list are from proton's INSTALL.md (https://github.com/apache/qpid-proton/blob/main/INSTALL.md) and the rest are from dispatch (https://github.com/apache/qpid-dispatch/blob/main/README)
RUN dnf -y install gcc gcc-c++ cmake libuuid-devel openssl-devel cyrus-sasl-devel cyrus-sasl-plain cyrus-sasl-gssapi swig git make valgrind emacs libwebsockets-devel python3-devel curl

# Create a main directory and clone the qpid-proton repo from github
RUN mkdir /main && cd /main && git clone https://gitbox.apache.org/repos/asf/qpid-proton.git  && cd /main/qpid-proton && mkdir /main/qpid-proton/build

WORKDIR /main/qpid-proton/build

# make and install proton
RUN cmake .. -DSYSINSTALL_BINDINGS=ON -DCMAKE_INSTALL_PREFIX=/usr -DSYSINSTALL_PYTHON=ON && make install

# Clone the qpid-dispatch git repo
RUN cd /main && git clone https://gitbox.apache.org/repos/asf/qpid-dispatch.git && mkdir /main/qpid-dispatch/build

WORKDIR /main/qpid-dispatch/build
RUN cmake .. -DCMAKE_INSTALL_PREFIX=/usr && make install

# Uncomment the following line if you would like to run all the dispatch unit tests and system tests. 
# RUN ctest -VV

# Start the dispatch router
ENTRYPOINT ["qdrouterd"]
#CMD ["/bin/bash"]