FROM ubuntu:14.04.5

RUN apt-get update && \
        apt-get install --no-install-recommends -y \
        software-properties-common \
        g++ \
        build-essential \
        curl \
        git \
        file \
        binutils \
        libssl-dev \
        pkg-config \
        libudev-dev \
        openssl && rm -rf /var/lib/apt/lists/*;

RUN curl -f -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

ADD . /smart-contracts

WORKDIR /smart-contracts

RUN npm install -g truffle@4.0.1 && npm cache clean --force;
RUN npm install bignumber.js && npm cache clean --force;
