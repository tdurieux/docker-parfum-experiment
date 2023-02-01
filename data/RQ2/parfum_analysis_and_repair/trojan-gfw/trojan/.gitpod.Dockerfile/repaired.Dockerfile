FROM gitpod/workspace-full

USER gitpod

RUN sudo apt-get update && \
    sudo apt-get install --no-install-recommends -y \
        build-essential \
        cmake \
        libboost-system-dev \
        libboost-program-options-dev \
        libssl-dev \
        default-libmysqlclient-dev && rm -rf /var/lib/apt/lists/*;
