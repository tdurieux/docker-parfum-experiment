FROM ubuntu:18.04

RUN apt-get update && apt-get install --no-install-recommends -y curl \
    wget \
    git \
    python \
    python-pip \
    vim \
    sudo \
    jq && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir awscli

# Add yq repository and install yq
RUN apt-get update && apt install --no-install-recommends -y software-properties-common && sudo add-apt-repository ppa:rmescandon/yq && apt update && apt install --no-install-recommends -y yq && rm -rf /var/lib/apt/lists/*;

# Install kubectl
RUN curl -f -LO https://storage.googleapis.com/kubernetes-release/release/v1.18.6/bin/linux/amd64/kubectl \
      && chmod +x ./kubectl && cp ./kubectl /bin

# Install eksctl
RUN curl -f --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp && mv /tmp/eksctl /bin

COPY ./codebuild/ ./app/

WORKDIR /app/
CMD ["./run_canarytest_china.sh"]