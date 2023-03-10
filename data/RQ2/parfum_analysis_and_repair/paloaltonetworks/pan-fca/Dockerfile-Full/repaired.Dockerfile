FROM ubuntu:bionic

ENV ANSIBLE_VERSION=2.6.4
ENV TERRAFORM_VERSION=0.11.10

RUN apt-get update -y && \
    apt-get install --no-install-recommends -y software-properties-common && \
    apt-get install --no-install-recommends -y \
    golang-go \
    python \
    curl \
    unzip \
    openssh-client && \
    apt-get install --no-install-recommends -y \
    python-dev \
    python-pip \
    git-core \
    build-essential \
    libssl-dev \
    libffi-dev && \
    pip install --no-cache-dir --upgrade setuptools cffi && \
    pip install --no-cache-dir ansible==${ANSIBLE_VERSION} \
        pandevice \
        pan-python \
        xmltodict \
        awscli \
        azure-cli \
        paramiko \
        ipaddress \
        requests \
        requests-toolbelt \
        cryptography==2.4.2 \
        jsonschema && \
    pip install --no-cache-dir --upgrade pandevice \
    go get golang.org/x/crypto/ssh && \
    ansible-galaxy install --force PaloAltoNetworks.paloaltonetworks && \
    curl -f https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip > terraform.zip && \
    unzip terraform.zip -d /bin && \
    rm -f terraform.zip && \
    apt-get -y autoremove && \
    apt-get -y autoclean && \
    apt-get -y clean all && \
    rm -rf /root/.cache/pip && \
    rm -rf /root/.pip/cache && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/cache/apt

ENTRYPOINT ["/bin/bash"]
