FROM node:6.11

# Force git to use HTTPS transport
RUN git config --global url.https://github.com/.insteadOf git://github.com/

# Install application dependencies (copie from node:6.11-onbuild)
RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app
ARG NODE_ENV
ENV NODE_ENV $NODE_ENV
COPY package.json /usr/src/app/
RUN npm install && npm cache clean --force
COPY . /usr/src/app

# Install extra tools
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y \
  jq && rm -rf /var/lib/apt/lists/*;

# Install typescript globally so we can rebuild scripts upon startup
RUN npm install -g typescript && npm cache clean --force;

# Prepare the application (done in dev startup script)
# RUN scripts/setup.sh

# Make sure we have some logs directory ready for use
RUN mkdir logs

# Setup proxy environment for runtime use (ie after build)
# REMOVE THIS PART IF YOU DO NOT NEED PROXY SUPPORT
COPY Docker/etc_apt_apt.conf /etc/apt/apt.conf
COPY Docker/etc_environment /etc/environment


# Change this according to the `server.*.json` content
EXPOSE 8080


CMD [ "sh", "scripts/startup.dev.server" ]