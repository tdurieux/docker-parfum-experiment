FROM node:16-bullseye
WORKDIR /tmp
COPY . .

RUN npm install -g ts-node@8.5.4 && npm cache clean --force;
RUN npm install && npm cache clean --force;

# Update the package listing, so we know what package exist:
RUN apt-get update && apt-get -y install --no-install-recommends podman slirp4netns systemd uidmap && rm -rf /var/lib/apt/lists/*; # Install security updates:
RUN apt-get -y upgrade

# Install application dependencies


# Create symbolic link so docker commands are handled as podman commands
RUN ln -s /usr/bin/podman /usr/bin/docker

# Delete cached files we don't need anymore (note that if you're
# using official Docker images for Debian or Ubuntu, this happens
# automatically, you don't need to do it yourself):
RUN apt-get clean

# Delete index files we don't need anymore:
RUN rm -rf /var/lib/apt/lists/*

RUN adduser --disabled-login --gecos api_user api_user
USER api_user
