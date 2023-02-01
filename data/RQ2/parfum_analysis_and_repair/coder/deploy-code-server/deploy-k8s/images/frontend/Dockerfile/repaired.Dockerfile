FROM bencdr/dev-env-base:latest

USER root

# Install Node.js
ARG NODE_VERSION=14
RUN curl -f -sL "https://deb.nodesource.com/setup_$NODE_VERSION.x" | bash -
RUN DEBIAN_FRONTEND="noninteractive" apt-get --no-install-recommends install -y nodejs && rm -rf /var/lib/apt/lists/*;

# Install yarn
RUN npm install -g yarn && npm cache clean --force;

USER coder
