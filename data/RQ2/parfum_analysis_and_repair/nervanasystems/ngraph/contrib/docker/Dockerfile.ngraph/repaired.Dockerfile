# ******************************************************************************
# Copyright 2017-2020 Intel Corporation
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
# ******************************************************************************

# Environment to build and unit-test ngraph

FROM ubuntu:16.04

RUN apt-get update && apt-get install --no-install-recommends -y \
        build-essential cmake \
        clang-3.9 clang-format-3.9 \
        git \
        wget patch diffutils zlib1g-dev libtinfo-dev \
        doxygen graphviz \
        python-sphinx python3-sphinx \
        python-pip && rm -rf /var/lib/apt/lists/*;

RUN apt-get clean autoclean && \
    apt-get autoremove -y
RUN pip install --no-cache-dir --upgrade pip

# allows for make html build under the doc/source directory as an interim build process
RUN pip install --no-cache-dir sphinx
RUN pip install --no-cache-dir breathe

# need numpy to successfully build docs for python_api
RUN pip install --no-cache-dir numpy

# release notes need this markdown extension
# RUN python3 -m pip install m2r

WORKDIR /home
