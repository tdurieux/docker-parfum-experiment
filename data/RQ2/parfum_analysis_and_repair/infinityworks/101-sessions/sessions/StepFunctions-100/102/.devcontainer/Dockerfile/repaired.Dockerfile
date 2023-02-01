FROM ubuntu:18.04

# Get some extra bits for ubuntu to allow add-apt-repository
RUN apt-get update \
	&& apt-get install --no-install-recommends -y \
		software-properties-common \
    && rm -rf /var/lib/apt/lists/*

# Intall Go
RUN add-apt-repository ppa:longsleep/golang-backports \
	&& apt-get update \
	&& apt-get install --no-install-recommends -y \
		gcc make \
		golang-go && rm -rf /var/lib/apt/lists/*;

RUN mkdir /root/go
ENV GOPATH=/root/go
ENV GOBIN=$GOPATH/bin

# Install node 10 and other key dependancies
RUN apt-get update \
	&& apt-get install --no-install-recommends -y \
		curl \
	&& curl -f --silent --location https://deb.nodesource.com/setup_10.x | bash - && rm -rf /var/lib/apt/lists/*;

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
		python3-pip \
		python3-setuptools \
		ssh \
		git \
		nodejs \
		jq \
		unzip \
	&& pip3 install --no-cache-dir --upgrade pip \
	&& pip install --no-cache-dir awscli --upgrade \
	&& npm install -g npm@latest \
	&& npm install -g serverless \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* && npm cache clean --force;

# Install latest version of terraform
RUN TERRAFORM_LATEST=$( curl -f -s https://checkpoint-api.hashicorp.com/v1/check/terraform | jq -r -M '.current_version') \
	&& curl -f -q "https://releases.hashicorp.com/terraform/${TERRAFORM_LATEST}/terraform_${TERRAFORM_LATEST}_linux_amd64.zip" --output /tmp/terraform.zip \
	&& unzip /tmp/terraform.zip -d /usr/local/bin \
	&& chmod +x /usr/local/bin/terraform \
	&& rm /tmp/terraform.zip