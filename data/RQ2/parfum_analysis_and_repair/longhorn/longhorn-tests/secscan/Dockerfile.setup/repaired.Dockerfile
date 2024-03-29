From alpine:latest

ARG TERRAFORM_VERSION=1.1.7

ENV WORKSPACE /src/longhorn-tests

WORKDIR $WORKSPACE

RUN apk add --no-cache rsync && \
    wget -q https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    mv terraform /usr/bin/terraform && \
    chmod +x /usr/bin/terraform && \
    apk add --no-cache openssh-client ca-certificates git bash && \
    ssh-keygen -t rsa -b 4096 -N "" -f ~/.ssh/id_rsa

COPY [".", "$WORKSPACE"]
