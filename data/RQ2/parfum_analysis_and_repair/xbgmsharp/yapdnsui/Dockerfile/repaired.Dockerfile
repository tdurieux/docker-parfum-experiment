# NodeJS + SSHD + myapp
#
# Base from ultimate-seed Dockerfile
# https://github.com/pilwon/ultimate-seed
#
# Mainly to run yapdnsui
# https://github.com/xbgmsharp/yapdnsui
#
# DOCKER-VERSION 0.9.1
# VERSION 0.0.1

# Pull base image.
FROM ubuntu:latest
MAINTAINER Francois Lacroix <xbgmsharp@gmail.com>

# Setup system and install tools
RUN echo "initscripts hold" | dpkg --set-selections
RUN echo 'alias ll="ls -lah --color=auto"' >> /etc/bash.bashrc

# Set locale
RUN apt-get -qqy --no-install-recommends install locales && rm -rf /var/lib/apt/lists/*;
RUN locale-gen --purge en_US en_US.UTF-8
RUN dpkg-reconfigure locales
ENV LC_ALL en_US.UTF-8

# Set ENV
ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive

# Update and Upgrade system
RUN apt-get update && apt-get -y upgrade

# Install deb dependencies for nodesource.com
RUN apt-get -y --no-install-recommends install curl && rm -rf /var/lib/apt/lists/*;

# Note the new setup script name for Node.js v0.12
RUN curl -f -sL https://deb.nodesource.com/setup_0.12 | bash -

# Install nodejs
RUN apt-get -y --no-install-recommends install nodejs && rm -rf /var/lib/apt/lists/*;

# Install nodejs dependencies
RUN npm install -g bower grunt-cli npm-check-updates && npm cache clean --force;
# Install my application dependencies
RUN npm install -g express express-generator jade request sqlite3 && npm cache clean --force;

# Install my dependencies
RUN apt-get -y --no-install-recommends install nano curl wget vim libsqlite3-0 && rm -rf /var/lib/apt/lists/*;
# Install Git
RUN apt-get -y --no-install-recommends install git-core && rm -rf /var/lib/apt/lists/*;

# Install SSH
RUN apt-get install --no-install-recommends -y openssh-server && rm -rf /var/lib/apt/lists/*;
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
RUN sed -ri 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config
RUN sed 's/#PermitRootLogin yes/PermitRootLogin yes/' -i /etc/ssh/sshd_config
RUN sed 's/PermitRootLogin without-password/PermitRootLogin yes/' -i /etc/ssh/sshd_config
RUN mkdir /var/run/sshd
RUN echo 'root:admin' | chpasswd

# Add app directory
RUN mkdir /app
ADD startup.sh /app/startup.sh
#ADD . /app

# Install `yapdnsui` from git
RUN cd /app && \
  git clone https://github.com/xbgmsharp/yapdnsui

RUN \
  cd /app/yapdnsui && \
  npm prune --production && \
  npm install --production --unsafe-perm && \
  npm rebuild && \
  bower --allow-root install && npm cache clean --force;

# Define environment variables
#ENV NODE_ENV production
ENV DEBUG yapdnsui
ENV PORT 8080

# Define working directory.
WORKDIR /app/yapdnsui

# Define default command.
# Start ssh and other services.
CMD ["/bin/bash", "/app/startup.sh"]

# Expose ports.
EXPOSE 22 8080

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Make sure the package repository is up to date
ONBUILD apt-get update && apt-get -y upgrade
ONBUILD apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
