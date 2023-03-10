# This is a Docker Image recommended for AutoDist users.
# For more usage instructions, please refer to docs/usage/tutorials/docker.md

ARG  TF_IMAGE_TAG=2.2.0-gpu
FROM tensorflow/tensorflow:${TF_IMAGE_TAG}

# Set default shell to /bin/bash
SHELL ["/bin/bash", "-cu"]

RUN rm -rf /etc/bash.bashrc

RUN apt-get update && apt-get install -y --allow-downgrades --allow-change-held-packages --no-install-recommends \
        build-essential \
        git \
        curl \
        vim \
        wget \
        unzip && rm -rf /var/lib/apt/lists/*;

RUN curl -f -O https://bootstrap.pypa.io/get-pip.py && \
    python get-pip.py && \
    rm get-pip.py

# Install AutoDist
RUN pip install --no-cache-dir future typing wheel pydocstyle prospector pytest pytest-cov kazoo==2.6.1
RUN echo 'import coverage; coverage.process_startup()' >> /usr/lib/python3.6/sitecustomize.py

COPY ./ autodist/

RUN cd autodist/ && \
    wget https://github.com/protocolbuffers/protobuf/releases/download/v3.11.0/protoc-3.11.0-linux-x86_64.zip && \
    unzip protoc-3.11.0-linux-x86_64.zip && \
    export PROTOC=$(pwd)/bin/protoc && \
    HOME=$(pwd) python setup.py bdist_wheel && \
    pip install --no-cache-dir dist/autodist*.whl

# Keep/Remove the source
# RUN rm -rf autodist/

# Install OpenSSH to communicate between containers
RUN apt-get install -y --no-install-recommends openssh-client openssh-server && \
    mkdir -p /var/run/sshd && rm -rf /var/lib/apt/lists/*;

# Setup SSH Daemon
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config

# Allow OpenSSH to talk to containers without asking for confirmation
RUN cat /etc/ssh/ssh_config | grep -v StrictHostKeyChecking > /etc/ssh/ssh_config.new && \
    echo "    StrictHostKeyChecking no" >> /etc/ssh/ssh_config.new && \
    mv /etc/ssh/ssh_config.new /etc/ssh/ssh_config

WORKDIR /mnt/
