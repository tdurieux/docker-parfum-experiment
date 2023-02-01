##
## Copyright (c) 2015-2021 University of Antwerp, Aloxy NV.
##
## This file is part of Sub-IoT.
## See https://github.com/Sub-IoT/Sub-IoT-Stack for further info.
##
## Licensed under the Apache License, Version 2.0 (the "License");
## you may not use this file except in compliance with the License.
## You may obtain a copy of the License at
##
##     http://www.apache.org/licenses/LICENSE-2.0
##
## Unless required by applicable law or agreed to in writing, software
## distributed under the License is distributed on an "AS IS" BASIS,
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.
##
FROM ubuntu:20.04

RUN apt-get update && apt-get install --no-install-recommends -y python3-pip libtool srecord wget git && rm -rf /var/lib/apt/lists/*;
RUN apt-get upgrade -y

COPY . /opt/sub-iot-stack
RUN tar xf /opt/sub-iot-stack/gcc-arm-none-eabi-8-2018-q4-major-linux.tar.bz2 -C /opt && rm /opt/sub-iot-stack/gcc-arm-none-eabi-8-2018-q4-major-linux.tar.bz2
RUN rm /opt/sub-iot-stack/gcc-arm-none-eabi-8-2018-q4-major-linux.tar.bz2
RUN pip3 install --no-cache-dir cmake
RUN apt-get autoclean -y
RUN apt-get autoremove -y
RUN apt-get clean

ENV PATH=/opt/gcc-arm-none-eabi-8-2018-q4-major/bin:$PATH

