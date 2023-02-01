# Setup development environment for OSConfig (Base: devops/docker/ubuntu20.04-amd64/Dockerfile)
# Creates an image, pre-provisioned with all necessary SDKs and tools for working with OSConfig
FROM ubuntu:20.04
ARG DEBIAN_FRONTEND=noninteractive
RUN apt -y update && apt-get -y --no-install-recommends install software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN apt -y update && apt-get -y --no-install-recommends install \
    apt-transport-https \
    build-essential \
    ca-certificates \
    cmake \
    curl \
    gcovr \
    gdb \
    git \
    jq \
    libcurl4-openssl-dev \
    libgmock-dev \
    libgtest-dev \
    liblttng-ust-dev \
    libssl-dev \
    ninja-build \
    rapidjson-dev \
    uuid-dev \
    wget && rm -rf /var/lib/apt/lists/*;

# CMake
RUN git clone https://github.com/Kitware/CMake --recursive -b v3.21.7
RUN cd CMake && ./bootstrap && make -j$(nproc) && make install && hash -r && rm -rf /git/CMake

# .NET Install
RUN curl -f https://packages.microsoft.com/keys/microsoft.asc | gpg --batch --dearmor > microsoft.gpg && \
    cp ./microsoft.gpg /etc/apt/trusted.gpg.d/ && \
    curl -f https://packages.microsoft.com/config/ubuntu/20.04/prod.list > ./microsoft-prod.list && \
    cp ./microsoft-prod.list /etc/apt/sources.list.d/ && \
    apt update -y && apt install --no-install-recommends -y dotnet-sdk-6.0 && rm -rf /var/lib/apt/lists/*;

# ZSH
ENV SHELL /bin/zsh
RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.1.2/zsh-in-docker.sh)" -- \
    -t https://github.com/denysdovhan/spaceship-prompt

# Terraform
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add - && \
    apt-add-repository "deb [arch=$(dpkg --print-architecture)] https://apt.releases.hashicorp.com $(lsb_release -cs) main" && \
    apt-get -y --no-install-recommends install terraform && rm -rf /var/lib/apt/lists/*;