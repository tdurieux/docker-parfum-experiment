############################################################
# Dockerfile to ElephantHead IOT Gateway API server
# Based on debian image
############################################################

# create base Debian image
FROM phusion/baseimage:0.9.18
MAINTAINER Paul Charlton techguru@byiq.com

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

RUN apt-get update
RUN apt-get dist-upgrade -y
RUN apt-get clean

# install node.js
RUN apt-get install --no-install-recommends nodejs -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends build-essential -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends npm -y && rm -rf /var/lib/apt/lists/*;
RUN npm -g install npm@latest && npm cache clean --force;
RUN apt-get install -y --no-install-recommends curl && rm -rf /var/lib/apt/lists/*;
RUN apt-get clean
RUN curl -f -sL https://deb.nodesource.com/setup_5.x | bash -
RUN ln -s /usr/bin/nodejs /usr/bin/node
RUN apt-get install --no-install-recommends nodejs -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends libavahi-compat-libdnssd-dev -y && rm -rf /var/lib/apt/lists/*;
RUN npm install && npm cache clean --force;

#
RUN useradd -ms /bin/bash modbus
USER modbus
WORKDIR /home/modbus
COPY . ./
USER root
RUN apt-get install --no-install-recommends git-core autoconf automake libtool -y && rm -rf /var/lib/apt/lists/*;


