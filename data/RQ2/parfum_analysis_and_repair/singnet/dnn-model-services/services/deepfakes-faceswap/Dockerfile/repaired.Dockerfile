FROM tensorflow/tensorflow:1.15.2-gpu-py3

ARG git_owner="singnet"
ARG git_repo="dnn-model-services"
ARG git_branch="master"
ARG snetd_version

ENV SINGNET_REPOS=/opt/singnet
ENV DNN_REPO_NAME=${git_repo}
ENV SERVICES_FOLDER=${SINGNET_REPOS}/${DNN_REPO_NAME}/services
ENV SERVICE_NAME=deepfakes-faceswap

RUN mkdir -p ${SINGNET_REPOS}

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    git \
    wget \
    nano \
    curl && rm -rf /var/lib/apt/lists/*;

# OpenCV dependencies
RUN apt-get install --no-install-recommends -y libglib2.0-0 libsm6 libxext6 libxrender-dev && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y python3 python3-pip ffmpeg && rm -rf /var/lib/apt/lists/*;

# Installing SNET Daemon
RUN SNETD_GIT_VERSION=$( curl -f -s https://api.github.com/repos/singnet/snet-daemon/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")' || echo "v5.0.1") && \
    SNETD_VERSION=${snetd_version:-${SNETD_GIT_VERSION}} && \
    cd /tmp && \
    wget https://github.com/singnet/snet-daemon/releases/download/${SNETD_VERSION}/snet-daemon-${SNETD_VERSION}-linux-amd64.tar.gz && \
    tar -xvf snet-daemon-${SNETD_VERSION}-linux-amd64.tar.gz && \
    mv snet-daemon-${SNETD_VERSION}-linux-amd64/snetd /usr/bin/snetd && \
    rm -rf snet-daemon-* && rm snet-daemon-${SNETD_VERSION}-linux-amd64.tar.gz

RUN cd ${SINGNET_REPOS} && \
    git clone -b ${git_branch} https://github.com/${git_owner}/${DNN_REPO_NAME}.git

# Getting the Deepfakes/faceswap codes
RUN cd ${SERVICES_FOLDER}/${SERVICE_NAME} && \
    git clone https://github.com/deepfakes/faceswap.git

# Getting content-server module
RUN cd ${SERVICES_FOLDER}/${SERVICE_NAME} && \
    pip3 install --no-cache-dir git+https://github.com/arturgontijo/content-server.git

RUN cd ${SERVICES_FOLDER}/${SERVICE_NAME} && \
    pip3 install --no-cache-dir -U pip==20.2.4 && \
    pip3 install --no-cache-dir -r requirements.txt && \
    sh buildproto.sh

WORKDIR ${SERVICES_FOLDER}/${SERVICE_NAME}
