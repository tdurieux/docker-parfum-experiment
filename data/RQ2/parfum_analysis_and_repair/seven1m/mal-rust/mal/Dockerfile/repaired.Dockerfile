FROM ubuntu:vivid
MAINTAINER Joel Martin <github@martintribe.org>

##########################################################
# General requirements for testing or common across many
# implementations
##########################################################

RUN apt-get -y update

# Required for running tests
RUN apt-get -y --no-install-recommends install make python && rm -rf /var/lib/apt/lists/*;

# Some typical implementation and test requirements
RUN apt-get -y --no-install-recommends install curl libreadline-dev libedit-dev && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /mal
WORKDIR /mal

##########################################################
# Specific implementation requirements
##########################################################

# For building node modules
RUN apt-get -y --no-install-recommends install g++ && rm -rf /var/lib/apt/lists/*;

# Add nodesource apt repo config for 0.12 stable
RUN curl -f -sL https://deb.nodesource.com/setup_0.12 | bash -

# Install nodejs
RUN apt-get -y --no-install-recommends install nodejs && rm -rf /var/lib/apt/lists/*;

# Link common name
RUN ln -sf nodejs /usr/bin/node

ENV NPM_CONFIG_CACHE /mal/.npm

