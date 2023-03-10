# Nunux Keeper Docker image.
#
# VERSION 0.0.1

FROM node:4

MAINTAINER Nicolas Carlier <https://github.com/ncarlier>

# Install packages
RUN apt-get update && apt-get install --no-install-recommends -y imagemagick && rm -rf /var/lib/apt/lists/*;

# Create app directories
RUN mkdir -p /usr/src/keeper /var/opt/keeper && rm -rf /usr/src/keeper

# Setup working directory
WORKDIR /usr/src/keeper

# Add package definition
COPY package.json /usr/src/keeper/

# Install
RUN npm install && npm cache clean --force;

# Ports
EXPOSE 3000 8080

# Copy sources
COPY . /usr/src/keeper

# Install app
RUN npm install --unsafe-perm && npm cache clean --force;

ENTRYPOINT ["/usr/local/bin/npm"]

CMD ["start"]
