ARG base_image
FROM ${base_image}

# base dependencies + jq
RUN apt-get update && \
  apt-get install -y apt-transport-https ca-certificates gnupg software-properties-common curl jq

# terraform
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add - && \
  apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" && \
  apt-get update && apt-get install -y terraform=0.14.7

# kubectl

RUN curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg && \
  echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list && \
  apt-get update && apt-get install -y kubectl

# gcloud
RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add - && \
  echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
  apt-get update && apt-get install -y google-cloud-sdk


# bosh cli
RUN curl -Lo ./bosh https://github.com/cloudfoundry/bosh-cli/releases/download/v6.4.4/bosh-cli-6.4.4-linux-amd64 && \
  install bosh /usr/local/bin

# bbl
RUN curl -Lo ./bbl https://github.com/cloudfoundry/bosh-bootloader/releases/download/v8.4.41/bbl-v8.4.41_linux_x86-64 && \
  install bbl /usr/local/bin
