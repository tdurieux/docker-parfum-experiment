#Sentiment Analysis.
FROM ubuntu:18.04

ARG git_owner="singnet"
ARG git_repo="nlp-services"
ARG git_branch="master"
ARG snetd_version

ENV SINGNET_DIR=/opt/singnet
ENV SERVICE_NAME=sentiment-analysis

RUN mkdir -p ${SINGNET_DIR}

RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get install -y \
    nano \
    git \
    wget \
    curl \
    apt-utils \
    net-tools \
    lsof \
    sudo \
    libudev-dev \
    libusb-1.0-0-dev

RUN apt-get install -y python3 python3-pip

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
    pip3 install -U pip==20.3.4 && \
    pip3 install -r requirements.txt && \
    python3 -c "import nltk; nltk.download('punkt')" && \
    python3 -c "import nltk; nltk.download('vader_lexicon')" && \
    sh buildproto.sh

RUN cd ${SINGNET_DIR}/${git_repo}/${SERVICE_NAME} && \
    python3 ../fetch_models.py

WORKDIR ${SINGNET_DIR}/${git_repo}/${SERVICE_NAME}