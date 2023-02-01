FROM ubuntu:18.04

RUN apt-get update && apt-get install --no-install-recommends -y curl \
    wget \
    git \
    python \
    python-pip \
    vim \
    sudo \
    jq && rm -rf /var/lib/apt/lists/*;


# Enable the Docker repository
RUN apt update && apt install --no-install-recommends -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" && rm -rf /var/lib/apt/lists/*;

# Install Docker CE
RUN apt update && apt install --no-install-recommends -y docker-ce && rm -rf /var/lib/apt/lists/*;

# Install yq
RUN sudo add-apt-repository ppa:rmescandon/yq && apt update && apt install --no-install-recommends -y yq && rm -rf /var/lib/apt/lists/*;

# Install Ruby and travis
RUN apt update && apt install --no-install-recommends -y ruby-dev libffi-dev make gcc && rm -rf /var/lib/apt/lists/*;
RUN gem install travis

RUN pip install --no-cache-dir awscli

# Install kustomize
RUN curl -f -LO https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv3.2.1/kustomize_kustomize.v3.2.1_linux_amd64 && mv kustomize_kustomize.v3.2.1_linux_amd64 /bin/kustomize && chmod u+x /bin/kustomize

# Install kubectl
RUN curl -f -o kubectl https://amazon-eks.s3-us-west-2.amazonaws.com/1.12.9/2019-06-21/bin/linux/amd64/kubectl \
      && chmod +x ./kubectl && cp ./kubectl /bin

# Install eksctl
RUN curl -f --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp && mv /tmp/eksctl /bin

# Install Kubebuilder which is required for make test
RUN wget https://github.com/kubernetes-sigs/kubebuilder/releases/download/v2.3.1/kubebuilder_2.3.1_linux_amd64.tar.gz \
 && tar -zxvf kubebuilder_2.3.1_linux_amd64.tar.gz \
 && mv kubebuilder_2.3.1_linux_amd64 /usr/local/kubebuilder \
 && rm -rf kubebuilder_2.3.1_linux_amd64.tar.gz

# Install dig, used for PrivateLink test.
RUN apt-get install --no-install-recommends -y dnsutils && rm -rf /var/lib/apt/lists/*;

# Add Golang
RUN sudo add-apt-repository -y ppa:longsleep/golang-backports && sudo apt-get update && sudo apt-get install --no-install-recommends -y golang-go && rm -rf /var/lib/apt/lists/*;

# This is how you start docker engine on container. Make sure container is
# running in privileged mode.
# I had to comment this line since codebuild overrides this.
# Uncomment this line if you want to use this as build environment for this project locally
# ENTRYPOINT sudo service docker start && bash
