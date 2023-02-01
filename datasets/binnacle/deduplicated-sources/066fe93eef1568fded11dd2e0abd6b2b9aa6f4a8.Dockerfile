#-------------------------------------------------------------------------------
# Dockerfile for building an ARM cross-compiler which we can use to build
# Ethereum C++ components for mobile Linux platforms such as Tizen, Sailfish
# and Ubuntu Touch.
#
# See http://ethereum.org/ to learn more about Ethereum.
# See http://doublethink.co/ to learn more about doublethinkco
#
# Copyright (c) 2015-2016 Kitsilano Software Inc (https://doublethink.co)
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
#-------------------------------------------------------------------------------

FROM ubuntu:14.04
MAINTAINER Bob Summerwill <bob@summerwill.net>

# So we DO appear to need this, perhaps because the contents in the package
# repository have changed since the base Dockerfile image was created?
# Not 100% sure, but without this we get errors about specific versions
# not being available in later steps.
RUN apt-get update

# External packages required by our scripts themselves
RUN apt-get install -y \
  bzip2=1.0.6-5 \
    git=1:1.9.1-1ubuntu0.1 \
   tree=1.6.0-1 \
  unzip=6.0-9ubuntu1.5 \
   wget=1.15-1ubuntu1.14.04.1

# External packages required by crosstool-ng
RUN apt-get update
RUN apt-get install --fix-missing
RUN apt-get install -y \
       automake=1:1.14.1-2ubuntu1 \
          bison=2:3.0.2.dfsg-2 \
build-essential=11.6ubuntu6 \
            cvs=2:1.12.13+real-12 \
           flex=2.5.35-10.1ubuntu2 \
           gawk=1:4.0.1+dfsg-2.1ubuntu2 \
          gperf=3.0.4-1 \
  libncurses5-dev=5.9+20140118-1ubuntu1 \
        libtool=2.4.2-1.7ubuntu1 \
  libexpat1-dev=2.1.0-4ubuntu1.1 \
        texinfo=5.2.0.dfsg.1-2

# Switch to a normal user account.  crosstool-ng refuses to run as root.
RUN useradd -ms /bin/bash xcompiler
USER xcompiler

# Copy our cross-building scripts into the container
ADD cross-build/ /home/xcompiler/webthree-umbrella/cross-build/

# And switch the working directory to the cross-compiler scripts
WORKDIR /home/xcompiler/webthree-umbrella/cross-build/ct-ng

