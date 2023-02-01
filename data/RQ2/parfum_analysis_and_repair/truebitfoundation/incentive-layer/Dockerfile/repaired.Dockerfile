FROM ubuntu:17.04
MAINTAINER Harley Swick

ENV PATH="${PATH}:/node-v6.11.3-linux-x64/bin"

RUN apt-get update && \
  apt-get install --no-install-recommends -y curl && \
  curl -f -sL https://deb.nodesource.com/setup_6.x | bash - && \
  apt-get install --no-install-recommends -y nodejs && \
  npm install -g ethereumjs-testrpc && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y git && \
	npm install truffle@v4.0.0-beta.0 -g && \
	git clone https://github.com/TrueBitFoundation/truebit-contracts && \
	cd truebit-contracts && \
	truffle test && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;