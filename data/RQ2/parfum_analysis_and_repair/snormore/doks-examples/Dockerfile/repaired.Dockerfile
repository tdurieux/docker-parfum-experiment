FROM golang:1.12

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y unzip jq && rm -rf /var/lib/apt/lists/*;

RUN go get -u github.com/digitalocean/doctl/cmd/doctl && \
    curl -f -LO https://storage.googleapis.com/kubernetes-release/release/$( curl -f -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/local/bin/kubectl && \
    curl -f https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | bash && \
    curl -f -sL https://run.linkerd.io/install | sh && \
    curl -f -O https://releases.hashicorp.com/terraform/0.12.3/terraform_0.12.3_linux_amd64.zip && \
    unzip terraform_0.12.3_linux_amd64 -d /usr/local/bin/

ENV PATH $PATH:/root/.linkerd2/bin

CMD [ "bash" ]
