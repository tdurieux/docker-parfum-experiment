FROM pytorch/pytorch:1.4-cuda10.1-cudnn7-runtime

ARG git_owner="singnet"
ARG git_repo="dnn-model-services"
ARG git_branch="master"
ARG snetd_version

ENV SINGNET_REPOS=/opt/singnet
ENV DNN_REPO_NAME=${git_repo}
ENV SERVICES_FOLDER=${SINGNET_REPOS}/${DNN_REPO_NAME}/services
ENV SERVICE_NAME=deoldify-colorizer

RUN mkdir -p ${SINGNET_REPOS}

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    git \
    wget \
    nano \
    curl && rm -rf /var/lib/apt/lists/*;

# OpenCV dependencies
RUN apt-get install --no-install-recommends -y libglib2.0-0 libsm6 libxext6 libxrender-dev libgl1-mesa-glx && rm -rf /var/lib/apt/lists/*;

# Installing SNET Daemon
RUN SNETD_GIT_VERSION=$( curl -f -s https://api.github.com/repos/singnet/snet-daemon/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")' || echo "v5.0.1") && \
    SNETD_VERSION=${snetd_version:-${SNETD_GIT_VERSION}} && \
    cd /tmp && \
    wget https://github.com/singnet/snet-daemon/releases/download/${SNETD_VERSION}/snet-daemon-${SNETD_VERSION}-linux-amd64.tar.gz && \
    tar -xvf snet-daemon-${SNETD_VERSION}-linux-amd64.tar.gz && \
    mv snet-daemon-${SNETD_VERSION}-linux-amd64/snetd /usr/bin/snetd && \
    rm -rf snet-daemon-* && rm snet-daemon-${SNETD_VERSION}-linux-amd64.tar.gz

# Cloning service repository, downloading models
RUN cd ${SINGNET_REPOS} && \
    git clone -b ${git_branch} https://github.com/${git_owner}/${DNN_REPO_NAME}.git && \
    cd ${DNN_REPO_NAME}/utils && \
    ./get_colorize_model.sh

# Installing deps and building protobuf messages
RUN cd ${SERVICES_FOLDER}/${SERVICE_NAME} && \
    pip install --no-cache-dir -U pip==20.2.4 && \
    pip install --no-cache-dir -r requirements.txt && \
    sh buildproto.sh

# DeOldify Repository
RUN cd ${SERVICES_FOLDER}/${SERVICE_NAME} && \
    git submodule update --init -- DeOldify && \
    cd DeOldify && \
    pip install --no-cache-dir -r requirements.txt

WORKDIR ${SERVICES_FOLDER}/${SERVICE_NAME}