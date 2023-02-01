FROM google/cloud-sdk:slim

USER root

RUN apt-get update && \
    apt-get install --no-install-recommends -y git gcc wget curl dnsutils jq google-cloud-sdk && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y openssl && \
    curl -f --retry 3 --retry-delay 3 https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash && rm -rf /var/lib/apt/lists/*;

RUN wget -O- --tries=3 https://carvel.dev/install.sh | bash

# https://kubernetes.io/docs/tasks/tools/install-kubectl/
RUN echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list && \
    curl -f -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
    apt-get update -y && apt-get install --no-install-recommends kubectl -y && rm -rf /var/lib/apt/lists/*;

RUN bosh_cli_version=$( curl -f --silent "https://api.github.com/repos/cloudfoundry/bosh-cli/releases/latest" | jq -r '.tag_name' | tr -d 'v') && \
    echo "Installing bosh_cli version ${bosh_cli_version}..." && \
    curl -f -LO --retry 3 --retry-delay 3 https://github.com/cloudfoundry/bosh-cli/releases/download/v${bosh_cli_version}/bosh-cli-${bosh_cli_version}-linux-amd64 && \
    chmod +x ./bosh-cli-${bosh_cli_version}-linux-amd64 && \
    mv ./bosh-cli-${bosh_cli_version}-linux-amd64 /usr/local/bin/bosh

RUN curl -f -sL --retry 3 --retry-delay 3 https://aka.ms/InstallAzureCLIDeb | bash
