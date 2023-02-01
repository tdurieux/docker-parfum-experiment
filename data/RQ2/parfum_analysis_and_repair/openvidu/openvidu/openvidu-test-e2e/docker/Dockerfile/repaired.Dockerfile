FROM ubuntu:20.04

LABEL maintainer="info@openvidu.io"

USER root

RUN apt-get update && apt-get -y upgrade

RUN apt-get install --no-install-recommends -y \
    software-properties-common \
    ca-certificates \
    curl \
    gnupg \
    lsb-release && \
    apt-get install -y --no-install-recommends apt-utils && rm -rf /var/lib/apt/lists/*;

# Install Node
RUN curl -f -sL https://deb.nodesource.com/setup_16.x | bash - && apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

# Java 11
RUN apt-get install --no-install-recommends -y openjdk-11-jdk-headless && rm -rf /var/lib/apt/lists/*;

# Maven
RUN apt-get install --no-install-recommends -y maven && rm -rf /var/lib/apt/lists/*;

# git
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;

# http-server
RUN npm install -g http-server@latest && npm cache clean --force;

# sudo
RUN apt-get -y --no-install-recommends install sudo && rm -rf /var/lib/apt/lists/*;

# ffmpeg (for ffprobe)
RUN apt-get install --no-install-recommends -y ffmpeg && rm -rf /var/lib/apt/lists/*;

# docker
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --batch --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu focal stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && apt-get install --no-install-recommends -y docker-ce docker-ce-cli containerd.io && rm -rf /var/lib/apt/lists/*;

# Cleanup
RUN rm -rf /var/lib/apt/lists/*
RUN apt-get autoremove --purge -y && apt-get autoclean

COPY entrypoint.sh /entrypoint.sh
RUN ["chmod", "+x", "/entrypoint.sh"]

ENTRYPOINT ["/entrypoint.sh"]
