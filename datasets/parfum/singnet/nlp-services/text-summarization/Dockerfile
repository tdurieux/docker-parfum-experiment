FROM nvidia/cuda:9.1-cudnn7-devel-ubuntu16.04

ARG git_owner="singnet"
ARG git_repo="nlp-services"
ARG git_branch="master"
ARG snetd_version

ENV SINGNET_DIR=/opt/singnet
ENV SERVICE_NAME=text-summarization

RUN mkdir -p ${SINGNET_DIR}

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y locales software-properties-common git
RUN add-apt-repository -y ppa:deadsnakes/ppa && \
      apt-get update && \
      apt-get upgrade -y && \
      apt-get install -y \
      python3.6 \
      python3.6-dev \
      build-essential \
      cmake \
      git \
      wget \
      curl \
      nano \
      default-jre \
      libgtk2.0-dev \
      python3.6-tk && \
      curl https://bootstrap.pypa.io/get-pip.py | python3.6
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8
ENV LANG en_US.UTF-8

# Install snet daemon
RUN SNETD_GIT_VERSION=`curl -s https://api.github.com/repos/singnet/snet-daemon/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")' || echo "v5.0.1"` && \
    SNETD_VERSION=${snetd_version:-${SNETD_GIT_VERSION}} && \
    cd /tmp && \
    wget https://github.com/singnet/snet-daemon/releases/download/${SNETD_VERSION}/snet-daemon-${SNETD_VERSION}-linux-amd64.tar.gz && \
    tar -xvf snet-daemon-${SNETD_VERSION}-linux-amd64.tar.gz && \
    mv snet-daemon-${SNETD_VERSION}-linux-amd64/snetd /usr/bin/snetd && \
    rm -rf snet-daemon*

RUN cd ${SINGNET_DIR} && \
    git clone -b ${git_branch} https://github.com/${git_owner}/${git_repo}.git

RUN cd ${SINGNET_DIR}/${git_repo}/${SERVICE_NAME} && \
    pip3.6 install -U pip==20.3.4 && \
    pip3.6 install -r requirements.txt && \
    sh buildproto.sh

RUN cd ${SINGNET_DIR}/${git_repo}/${SERVICE_NAME} && \
    git submodule update --init -- opennmt-py

RUN cd ${SINGNET_DIR}/${git_repo}/${SERVICE_NAME} && \
    python3.6 ../fetch_models.py

WORKDIR ${SINGNET_DIR}/${git_repo}/${SERVICE_NAME}