FROM ubuntu:18.04

# Application parameters and variables
ENV application_directory=/home/node/scheduler

# Create app directory
WORKDIR $application_directory

# Install Nodejs on Ubuntu 18.04
RUN apt update
RUN apt -y --no-install-recommends install curl dirmngr apt-transport-https lsb-release ca-certificates && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_12.x | /bin/bash
RUN apt -y --no-install-recommends install nodejs && rm -rf /var/lib/apt/lists/*;

# install docker-machine: https://docs.docker.com/machine/install-machine/
RUN base=https://github.com/docker/machine/releases/download/v0.16.2 && curl -f -L $base/docker-machine-$(uname -s)-$(uname -m) >/tmp/docker-machine && mv /tmp/docker-machine /usr/local/bin/docker-machine && chmod +x /usr/local/bin/docker-machine

# install aws-cli
RUN apt -y --no-install-recommends install awscli && rm -rf /var/lib/apt/lists/*;

RUN npm install -g yarn && npm cache clean --force;

# Bundle app source and install dependencies
# dont copy node_modules directory
COPY . .

RUN yarn install && yarn cache clean;

# Cleanup
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

ADD https://github.com/Yelp/dumb-init/releases/download/v1.2.2/dumb-init_1.2.2_amd64 /usr/local/bin/dumb-init
RUN chmod +x /usr/local/bin/dumb-init

CMD dumb-init node dist/master/scheduler/run.js
