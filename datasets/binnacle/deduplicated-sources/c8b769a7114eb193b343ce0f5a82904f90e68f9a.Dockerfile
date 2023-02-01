# Copyright (c) Microsoft Corporation
# All rights reserved.
#
# MIT License
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
# documentation files (the "Software"), to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and
# to permit persons to whom the Software is furnished to do so, subject to the following conditions:
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED *AS IS*, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING
# BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
# DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
#
# Copyright (c) Peking University 2018
#
# The software is released under the Open-Intelligence Open Source License V1.0.
# The copyright owner promises to follow "Open-Intelligence Open Source Platform
# Management Regulation V1.0", which is provided by The New Generation of 
# Artificial Intelligence Technology Innovation Strategic Alliance (the AITISA).

FROM ubuntu:16.04

#
# Preparation
#

ENV NVIDIA_VERSION=current
ENV NV_DRIVER=/var/drivers/nvidia/$NVIDIA_VERSION
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$NV_DRIVER/lib:$NV_DRIVER/lib64
ENV PATH=$PATH:$NV_DRIVER/bin

WORKDIR /root/

RUN apt-get update && \
    apt-get -y install wget build-essential python python-pip git

COPY copied_file/exporter/* /usr/local/

RUN wget https://mirrors.aliyun.com/docker-ce/linux/static/stable/x86_64/docker-17.06.2-ce.tgz

RUN cp docker-17.06.2-ce.tgz /usr/local
RUN tar xzvf /usr/local/docker-17.06.2-ce.tgz -C /usr/local/
RUN cp -r /usr/local/docker/* /usr/bin/

#
# start
#

CMD python /usr/local/job_exporter.py /datastorage/prometheus 30
