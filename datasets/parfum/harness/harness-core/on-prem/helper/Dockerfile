FROM ubuntu:18.04

# Install dependencies
RUN apt-get update && apt-get install -y \
    software-properties-common \
    curl \
    python-pip \
 && rm -rf /var/lib/apt/lists/*

# Install yq : This is not same as that of pip install yq
RUN add-apt-repository -y ppa:rmescandon/yq \
 && apt-get update \
 && apt-get install yq \
 && rm -rf /var/lib/apt/lists/*

# Install docker
RUN curl -fsSL https://get.docker.com -o get-docker.sh \
 && sh get-docker.sh \
 && rm get-docker.sh

# Install helm
RUN curl https://raw.githubusercontent.com/helm/helm/master/scripts/get | bash

RUN pip install click