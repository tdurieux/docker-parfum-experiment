# Copyright (c) 2022, TU Wien
# All rights reserved.
#
# This source code is licensed under the BSD-style license found in the
# LICENSE file in the root directory of this source tree.

FROM ubuntu:focal

RUN apt-get update &&\
    apt-get install -yq --no-install-recommends \
    python3 \
    python3-pip \
    curl \
    vim \
    iputils-ping \
    git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# node and npm
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - && \
    apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;

# Install Jupyterhub
RUN npm install -g configurable-http-proxy && npm cache clean --force;
RUN python3 -m pip install jupyterhub
RUN python3 -m pip install --upgrade notebook

# INSTALL grader-service
COPY ./grader_labextension /grader_labextension
COPY ./grader_convert /grader_convert

# install grading service
RUN python3 -m pip install -r /grader_labextension/requirements.txt && \
    python3 -m pip install -r /grader_convert/requirements.txt

RUN python3 -m pip install --no-use-pep517 /grader_convert/ && \
    python3 -m pip install /grader_labextension

RUN useradd -m -s /bin/bash -N -u 1000 jovyan
RUN echo "jovyan:jupyter" | chpasswd

RUN useradd -m -s /bin/bash -N -u 1001 user1
RUN echo "user1:password" | chpasswd
RUN useradd -m -s /bin/bash -N -u 1002 user2
RUN echo "user2:password" | chpasswd
RUN useradd -m -s /bin/bash -N -u 1003 user3
RUN echo "user3:password" | chpasswd

USER jovyan
RUN git config --global user.name "jovyan"
RUN git config --global user.email "jovyan@mail.com"
USER user1
RUN git config --global user.name "user1"
RUN git config --global user.email "user1@mail.com"
USER user2
RUN git config --global user.name "user2"
RUN git config --global user.email "user2@mail.com"
USER user2
RUN git config --global user.name "user3"
RUN git config --global user.email "user3@mail.com"
USER root


ENTRYPOINT ["jupyterhub", "-f", "/jupyterhub_labextension_config.py"]
