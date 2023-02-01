# Copyright (c) 2022, TU Wien
# All rights reserved.
#
# This source code is licensed under the BSD-style license found in the
# LICENSE file in the root directory of this source tree.

FROM jupyter/base-notebook:lab-3.4.3

USER root

RUN apt-get update && \
    apt-get install -yq --no-install-recommends \
    git && rm -rf /var/lib/apt/lists/*;

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# INSTALL grader-service
COPY ./grader_labextension /grader_labextension
COPY ./grader_convert /grader_convert

# install grading service
RUN python3 -m pip install -r /grader_labextension/requirements.txt && \
    python3 -m pip install -r /grader_convert/requirements.txt

RUN python3 -m pip install --no-use-pep517 /grader_convert/
RUN python3 -m pip install /grader_labextension

USER jovyan
