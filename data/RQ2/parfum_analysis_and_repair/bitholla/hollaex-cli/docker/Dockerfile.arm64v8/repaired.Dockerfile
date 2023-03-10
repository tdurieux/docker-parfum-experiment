FROM arm64v8/ubuntu:18.04

RUN apt-get update && apt-get install --no-install-recommends -y git curl sudo docker.io docker-compose && rm -rf /var/lib/apt/lists/*;

RUN curl -f --retry 3 --connect-timeout 10 -LO https://storage.googleapis.com/kubernetes-release/release/v1.13.4/bin/linux/amd64/kubectl && chmod +x ./kubectl && mv ./kubectl /usr/local/bin/kubectl

RUN curl -f --retry 3 --connect-timeout 10 -LO https://get.helm.sh/helm-v2.16.1-linux-arm64.tar.gz && tar -zxvf helm-v2.16.1-linux-arm64.tar.gz && mv linux-arm64/helm /usr/local/bin/helm && rm helm-v2.16.1-linux-arm64.tar.gz

RUN curl -f --retry 3 --connect-timeout 10 https://raw.githubusercontent.com/bitholla/hollaex-cli/master/install.sh | bash

COPY docker/run.sh /run.sh
RUN chmod +x /run.sh

WORKDIR /root

ENTRYPOINT ["/run.sh"]