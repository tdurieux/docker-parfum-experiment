FROM us.gcr.io/scytale-registry/aws-cli:latest
# FROM ubuntu:18.04

RUN apk add --no-cache jq curl coreutils wget unzip vim
# RUN apt update && \
#    apt install -y curl && \
#    apt install coreutils && \
#    apt install -y wget && \
#    apt install -y unzip && \
#    apt install -y jq && \
#    apt install -y vim

# install yq required for xform YAML to JSON
#RUN apt-get install -y software-properties-common && \
#    add-apt-repository ppa:rmescandon/yq && \
#    apt update && apt install -y yq

RUN curl -f -LO https://storage.googleapis.com/kubernetes-release/release/$( curl -f -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \
    chmod +x kubectl
RUN wget https://releases.hashicorp.com/vault/1.4.2/vault_1.4.2_linux_amd64.zip && \
    unzip vault_1.4.2_linux_amd64.zip && \
    mkdir -p /usr/local/bin/ && \
    mv vault /usr/local/bin/ && \
    rm -f vault_1.4.2_linux_amd64.zip

COPY demoscript /usr/local/bin
COPY demo.mars.sh /root/demo.sh
#COPY run-sidecar.sh execute-get-token.sh execute-get-vault-secrets.sh \
#    get-vault-secrets.sh /usr/local/bin/

# adding Spire agent
RUN pwd
RUN VERSION=1.0.2 && \
    wget https://github.com/spiffe/spire/releases/download/v${VERSION}/spire-${VERSION}-linux-x86_64-glibc.tar.gz && \
    tar zvxf spire-${VERSION}-linux-x86_64-glibc.tar.gz && \
    mkdir -p /opt/spire/bin && \
    mv spire-${VERSION}/bin/spire-agent /opt/spire/bin/ && \
    rm -rf spire-${VERSION}/ && \
    rm -f spire-${VERSION}-linux-x86_64-glibc.tar.gz

RUN cd /root

# run it forever
CMD ["/bin/bash", "-c", "tail -f /dev/null"]
