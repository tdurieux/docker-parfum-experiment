FROM python:3.10.3-slim

ARG TERRAFORM_VERSION=1.1.6
ARG TERRAGRUNT_VERSION=0.36.0

RUN apt-get update

# Install Terraform
RUN apt-get install --no-install-recommends -y gnupg software-properties-common curl unzip git && \
    curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add - && \
    apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" && \
    apt-get update && \
    apt-get install -y --no-install-recommends terraform=$TERRAFORM_VERSION && rm -rf /var/lib/apt/lists/*;

RUN curl -f -L https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_amd64 -o /usr/local/bin/terragrunt && \
    chmod +x /usr/local/bin/terragrunt

# Install Docker
RUN curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | apt-key add - && \
    add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
    $(lsb_release -cs) \
    stable" && \
    apt-get update && \
    apt-get -y --no-install-recommends install docker-ce && rm -rf /var/lib/apt/lists/*;

# Install AWS Session Manager Plugin
RUN curl -f "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" -o "session-manager-plugin.deb" && \
    dpkg -i session-manager-plugin.deb

# Install AWS CLI
RUN curl -f "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install

ARG UNAME=hostcaller
ARG DOCKER_GID
ARG CALLER_UID
ARG CALLER_GID

# Configure the host caller user/group and host docker group in the image
RUN groupadd -g $CALLER_GID -o $UNAME && \
    useradd -m -u $CALLER_UID -g $CALLER_GID -o -s /bin/bash $UNAME && \
    groupadd -g $DOCKER_GID -o hostdocker && \
    usermod --append --groups hostdocker $UNAME

USER $UNAME

# Install Python dependencies
RUN pip install --no-cache-dir boto3 dynaconf invoke requests

WORKDIR /vast/cloud/aws

ENTRYPOINT [ "python", "./cli/main.py" ]
