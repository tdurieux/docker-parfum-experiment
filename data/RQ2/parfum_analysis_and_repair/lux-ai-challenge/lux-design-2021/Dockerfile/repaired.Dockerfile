# This docker file basically replicates the competition environment but using the lux-ai-2021 tool instead

FROM ubuntu:18.04

# nvm environment variables
ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 14.16.0

# basic setups
RUN apt-get update && apt-get install -y -q --no-install-recommends \
        apt-transport-https \
        ca-certificates \
        curl \
        wget \
        software-properties-common && rm -rf /var/lib/apt/lists/*;

# install nvm
# https://github.com/creationix/nvm#install-script
RUN curl -f -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.2/install.sh | bash

# install node and npm
RUN . $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

# add node and npm to path so the commands are available
ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

# confirm installation
RUN node -v
RUN npm -v

# install lux ai

RUN npm i -g @lux-ai/2021-challenge@latest && npm cache clean --force;

# install tooling for other languages

# Java
RUN apt-get install --no-install-recommends -y default-jre && rm -rf /var/lib/apt/lists/*;

# Python
RUN apt-get install --no-install-recommends -y python3.8 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;
# set python3.8 as default
RUN ln -s python3.8 /usr/bin/python


# install python packages
RUN pip3 install --no-cache-dir numpy
RUN pip3 install --no-cache-dir scipy

# C++
RUN apt-get install --no-install-recommends g++ -y && rm -rf /var/lib/apt/lists/*;