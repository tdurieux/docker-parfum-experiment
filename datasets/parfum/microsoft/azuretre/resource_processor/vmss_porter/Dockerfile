FROM python:3.8-slim-buster

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install Azure CLI
ARG AZURE_CLI_VERSION=2.37.0-1~buster
COPY scripts/azure-cli.sh /tmp/
RUN export AZURE_CLI_VERSION=${AZURE_CLI_VERSION} \
    && /tmp/azure-cli.sh

# Install Terraform
ARG TERRAFORM_VERSION="1.1.5"
COPY ./scripts/terraform.sh /tmp/
RUN apt-get update \
    && apt-get -y install unzip="6.0-23+deb10u2" --no-install-recommends \
    && bash /tmp/terraform.sh "${TERRAFORM_VERSION}" /usr/bin \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# Install Porter
ARG PORTER_MIRROR=https://cdn.porter.sh
ARG PORTER_PERMALINK=v0.38.11
ARG PORTER_PKG_PERMALINK=latest
ARG PORTER_HOME=/root/.porter/
COPY scripts/porter.sh /tmp/
RUN export PORTER_MIRROR=${PORTER_MIRROR} \
    PORTER_PERMALINK=${PORTER_PERMALINK} \
    PORTER_PKG_PERMALINK=${PORTER_PKG_PERMALINK} \
    PORTER_HOME=${PORTER_HOME} \
    && /tmp/porter.sh

ENV PATH ${PORTER_HOME}:$PATH

# Install Docker
RUN apt-get update && apt-get install -y apt-transport-https="1.8.2.3" ca-certificates="20200601~deb10u2" curl="7.64.0-4+deb10u2" gnupg="2.2.12-1+deb10u2" lsb-release="10.2019051400" --no-install-recommends \
    && curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg \
    && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" \
    | tee /etc/apt/sources.list.d/docker.list > /dev/null \
    && apt-get update && apt-get install -y docker-ce="5:20.10.17~3-0~debian-buster" docker-ce-cli="5:20.10.17~3-0~debian-buster" containerd.io="1.6.6-1" --no-install-recommends \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# Install jq
RUN apt-get update && apt-get install -y jq="1.5+dfsg-2+b1" --no-install-recommends && apt-get clean -y && rm -rf /var/lib/apt/lists/*

ENV PYTHONPATH .

COPY ./vmss_porter/requirements.txt /tmp/
RUN pip3 --no-cache-dir install -r /tmp/requirements.txt

COPY . /app

WORKDIR /app/

EXPOSE 8080

CMD ["./run.sh"]
