FROM public.ecr.aws/ubuntu/ubuntu:18.04

# Build time parameters
ARG SERVICE=applicationautoscaling

RUN apt-get update && apt-get install --no-install-recommends -y curl \
    wget \
    git \
    python3.8 \
    python3-pip \
    python3.8-dev \
    vim \
    sudo \
    jq \
    unzip && rm -rf /var/lib/apt/lists/*;

# Install awscli
RUN curl -f "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
 && unzip -qq awscliv2.zip \
 && ./aws/install

# Add yq repository and install yq
RUN apt-get update && apt install --no-install-recommends -y software-properties-common \
 && sudo add-apt-repository ppa:rmescandon/yq \
 && apt update && apt install --no-install-recommends -y yq && rm -rf /var/lib/apt/lists/*;

# Install kubectl
RUN curl -f -LO https://storage.googleapis.com/kubernetes-release/release/v1.18.6/bin/linux/amd64/kubectl \
 && chmod +x ./kubectl \
 && cp ./kubectl /bin

# Install eksctl
 RUN curl -f --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp && mv /tmp/eksctl /bin

# Install Helm
RUN curl -f -q -L "https://get.helm.sh/helm-v3.7.0-linux-amd64.tar.gz" | tar zxf - -C /usr/local/bin/ \
 && mv /usr/local/bin/linux-amd64/helm /usr/local/bin/helm \
 && rm -r /usr/local/bin/linux-amd64 \
 && chmod +x /usr/local/bin/helm

ENV SERVICE_REPO_PATH=/$SERVICE-controller
COPY ./test/e2e/requirements.txt requirements.txt

RUN ln -s /usr/bin/python3.8 /usr/bin/python \
 && python -m pip install --upgrade pip

RUN python -m pip install -r requirements.txt

WORKDIR /$SERVICE_REPO_PATH
CMD ["./test/canary/scripts/run_test.sh"]