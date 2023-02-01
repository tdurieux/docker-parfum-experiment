# https://github.com/dwightjack/grunt-email-boilerplate

# Pull base image.
FROM ubuntu
MAINTAINER Javier Villanueva

RUN sed -i 's/# \(.*multiverse$\)/\1/g' /etc/apt/sources.list
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y upgrade

# Install Ruby
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y ruby ruby-dev && rm -rf /var/lib/apt/lists/*;

# Install build essentials (needed to build gems)
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y build-essential software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y curl git && rm -rf /var/lib/apt/lists/*;
#RUN DEBIAN_FRONTEND=noninteractive apt-get install -y python python-dev python-pip python-virtualenv

# Dependencies
RUN gem install compass
RUN gem install premailer
RUN gem install hpricot

# Install node.js
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y nodejs npm && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y nodejs-legacy && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libpng-dev && rm -rf /var/lib/apt/lists/*;

RUN npm install -g grunt && npm cache clean --force;
RUN npm install -g yo && npm cache clean --force;
RUN npm install -g generator-htmlemail && npm cache clean --force;

# Set environment variables.
ENV HOME /root

# Define mountable directories.
VOLUME ["data"]

# Define working directory.
WORKDIR /data

# Define default command.
RUN echo initiate the generator in an empty directory with 'yo htmlemail'

EXPOSE 8000
