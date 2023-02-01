# Copyright 2019 The Kubernetes Authors.
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

# python:2-alpine as of April 30th, 2019
ARG BASE_IMAGE=python@sha256:20ecc1d602d2993516daa9c480d42ee6c99c61a4fdd3f646991247e69c1c12cb
FROM ${BASE_IMAGE}

# install from requirements.txt and ensure that all requirements match
# pip freeze after, guaranteeing that we will install the same packages if we
# build again
COPY requirements.txt /requirements.txt
RUN pip install -r /requirements.txt && \
    echo "freezing deps, please make sure requirements.txt matches" && \
    pip freeze | tee /newrequirements.txt && \
    diff /requirements.txt /newrequirements.txt
# To enable debugging:
# RUN pip install ipython ipdb
# pair with the following at breakpoints in python code:
# import ipdb ; ipdb.set_trace()
COPY check-zone.py /usr/local/bin/check-zone
CMD /bin/sh
