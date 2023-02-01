FROM golang:alpine

ARG TERRAFORM_VERSION=0.12.10
ENV TERRAFORM_VERSION=$TERRAFORM_VERSION


RUN apk update && \
    apk upgrade --update-cache --available && \
    apk add --no-cache curl git jq bash openssh unzip gcc g++ make ca-certificates && \
    curl -f https://raw.githubusercontent.com/golang/dep/master/install.sh | sh

RUN curl -f -LO https://storage.googleapis.com/kubernetes-release/release/$( curl -f -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/local/bin
RUN mkdir tmp && \
    curl -f "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" -o tmp/terraform.zip && \
    unzip tmp/terraform.zip -d /usr/local/bin && \
    chmod +x /usr/local/bin/terraform && \
    rm -rf tmp

WORKDIR $GOPATH/src/github.com/k3s-io/k3s-io/k3s/tests/e2e

COPY . .

