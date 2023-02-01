FROM alpine

RUN apk add --no-cache --update make curl git bash ncurses jq py-pip openssl docker-compose
RUN pip install --no-cache-dir shyaml
WORKDIR /home

# Install kubectl
RUN curl -f -LO https://storage.googleapis.com/kubernetes-release/release/$( curl -f -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/local/bin/kubectl

# Install helm
RUN wget https://get.helm.sh/helm-v3.5.2-linux-amd64.tar.gz && tar xvzf helm-*.tar.gz && mv linux-amd64/helm /usr/local/bin/helm && rm helm-*.tar.gz

#RUN curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash

RUN addgroup -S deployer && adduser -S deployer -G deployer -h /home/deployer/
USER deployer
WORKDIR /home/deployer
RUN helm repo add incubator https://charts.helm.sh/incubator
ADD kubeconfig /home/deployer/.kube/config
ADD deploy.sh /home/deployer/deploy.sh
