ARG REGISTRY
ARG CODE_VERSION
FROM ${REGISTRY}/lib_base:${CODE_VERSION}

LABEL maintainer="Dan Crankshaw <dscrankshaw@gmail.com>"

# install docker and other apt-installable dependencies
RUN apt-get update -qq && apt-get install -y -qq --no-install-recommends \
    wget apt-transport-https ca-certificates curl gnupg-agent software-properties-common clang-format redis-server \
    && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - \
    && add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
    && apt-get update -qq \
    && apt-get install --no-install-recommends -y -qq docker-ce \
    && apt-get install --no-install-recommends -y -qq python3 python3-dev python3-pip \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get autoremove -y

ENV PIP_DEFAULT_TIMEOUT=100
RUN pip3 install --no-cache-dir --upgrade pip

# Alias python to python3
RUN echo '#!/bin/bash\npython3 "$@"' > /usr/bin/python && \
    chmod +x /usr/bin/python

RUN pip3 install --no-cache-dir cloudpickle==0.5.* pyzmq==17.0.* requests==2.20.0 scikit-learn==0.19.* \
  numpy==1.14.* pyyaml >=4.2b1 docker==3.1.* kubernetes==5.0.* tensorflow==1.13.* mxnet==1.4.* pyspark==2.3.* \
  xgboost==0.7.* urllib3==1.24.* keras==2.2.*# CI is broken when urllib3's version is 1.25.1. Delete urllib3==1.24.* later once version compatibility is stabilized

# Install PyTorch
RUN pip3 install --no-cache-dir torch==1.1.* torchvision==0.3.*

# Install kubectl
RUN curl -f -LO https://storage.googleapis.com/kubernetes-release/release/$( curl -f -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl \
      && chmod +x kubectl \
      && mv kubectl /usr/local/bin/

# Install Java
RUN mkdir -p /usr/share/man/man1 && \
    apt-get update -qq -y && \
    apt-get install --no-install-recommends openjdk-8-jre openjdk-8-jdk-headless -y && rm -rf /var/lib/apt/lists/*;

# Marking R as unmaintained for now
# Install R
# RUN apt-get update -qq && apt-get install -y -qq --no-install-recommends r-base libxml2-dev gfortran \
#   && rm -rf /var/lib/apt/lists/*
# COPY containers/R/tests/install_test_dependencies.R /install_test_dependencies.R
# RUN Rscript /install_test_dependencies.R

ENTRYPOINT ["bash"]

# vim: set filetype=dockerfile:
