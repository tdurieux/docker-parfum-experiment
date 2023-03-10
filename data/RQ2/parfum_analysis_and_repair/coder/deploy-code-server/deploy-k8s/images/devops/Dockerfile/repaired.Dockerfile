FROM bencdr/dev-env-base:latest

USER root

RUN apt-get update
RUN apt-get install --no-install-recommends -y apt-transport-https gnupg && rm -rf /var/lib/apt/lists/*;

# Install kubectl
RUN curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list && \
    apt-get update && apt-get install --no-install-recommends -y kubectl && rm -rf /var/lib/apt/lists/*;

# Install helm
RUN curl -f https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Install gcloud
RUN curl -fsSLo /usr/share/keyrings/cloud.google.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" |   tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    apt-get update && apt-get install --no-install-recommends -y google-cloud-sdk && rm -rf /var/lib/apt/lists/*;

# Install AWS CLI
RUN pip3 install --no-cache-dir awscli

USER coder

# Install terraform
RUN brew tap hashicorp/tap && \
    brew install hashicorp/tap/terraform

# Install kubectx
RUN brew install kubectl

# Install Docker
RUN sudo apt-get install --no-install-recommends -y docker.io systemd systemd-sysv && rm -rf /var/lib/apt/lists/*;
RUN systemctl enable docker

USER coder