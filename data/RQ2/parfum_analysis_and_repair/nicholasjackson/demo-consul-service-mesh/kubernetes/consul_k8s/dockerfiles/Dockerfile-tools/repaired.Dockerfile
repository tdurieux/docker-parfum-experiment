FROM ubuntu:latest

RUN apt-get update && apt-get install --no-install-recommends -y curl apt-transport-https ca-certificates software-properties-common gnupg-agent vim zip && rm -rf /var/lib/apt/lists/*;

# Install Kind
RUN curl -f -Lo ./kind https://github.com/kubernetes-sigs/kind/releases/download/v0.5.1/kind-$(uname)-amd64 && \
    chmod +x ./kind && \
    mv ./kind /usr/local/bin/kind

# Install Kubectl
RUN curl -f -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list && \
    apt-get update && \
    apt-get install --no-install-recommends -y kubectl && rm -rf /var/lib/apt/lists/*;

# Install Helm
RUN curl -f -L https://git.io/get_helm.sh | bash

# Install Docker CLI
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu  $(lsb_release -cs)  stable" && \
    apt-get update && \
    apt-get install -y --no-install-recommends docker-ce-cli && rm -rf /var/lib/apt/lists/*;

# Install Consul CLI
RUN curl -f -sL https://releases.hashicorp.com/consul/1.6.1/consul_1.6.1_linux_amd64.zip -o consul.zip && \
    unzip consul.zip && \
    mv consul /usr/local/bin
