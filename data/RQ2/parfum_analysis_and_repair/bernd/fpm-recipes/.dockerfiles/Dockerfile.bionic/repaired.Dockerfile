FROM ubuntu:18.04

RUN apt-get update && \
	DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -y install curl ruby-dev build-essential git pkg-config python-pip && \
	gem install --no-document bundler && \
	pip install --no-cache-dir virtualenv-tools && \
	apt-get clean && rm -rf /var/lib/apt/lists/*;

WORKDIR /recipe
