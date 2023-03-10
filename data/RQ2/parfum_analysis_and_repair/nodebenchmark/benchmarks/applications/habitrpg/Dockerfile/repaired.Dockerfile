FROM ubuntu:trusty

MAINTAINER Sabe Jones <sabe@habitica.com>

# Avoid ERROR: invoke-rc.d: policy-rc.d denied execution of start.
RUN echo -e '#!/bin/sh\nexit 0' > /usr/sbin/policy-rc.d

# Install prerequisites
RUN apt-get update
RUN apt-get install --no-install-recommends -y \
    build-essential \
    curl \
    git \
    libfontconfig1 \
    libfreetype6 \
    libkrb5-dev \
    python && rm -rf /var/lib/apt/lists/*;

# Install NodeJS
RUN curl -f -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

# Clean up package management
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

# Install global packages
RUN npm install -g gulp grunt-cli bower && npm cache clean --force;

# Clone Habitica repo and install dependencies
WORKDIR /habitrpg
RUN git clone https://github.com/HabitRPG/habitrpg.git /habitrpg
RUN npm install && npm cache clean --force;
RUN bower install --allow-root

# Create environment config file and build directory
RUN cp config.json.example config.json
RUN mkdir -p ./website/build

# Start Habitica
EXPOSE 3000
CMD ["npm", "start"]
