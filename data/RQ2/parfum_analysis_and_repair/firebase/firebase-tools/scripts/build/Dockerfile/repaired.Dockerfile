FROM node:16

# Install dependencies
RUN apt-get update && \
    apt-get install --no-install-recommends -y curl git jq && rm -rf /var/lib/apt/lists/*;

# Install hub
RUN curl -fsSL --output hub.tgz https://github.com/github/hub/releases/download/v2.14.2/hub-linux-amd64-2.14.2.tgz
RUN tar --strip-components=2 -C /usr/bin -xf hub.tgz hub-linux-amd64-2.14.2/bin/hub && rm hub.tgz

# Upgrade npm to 8.
RUN npm install --global npm@8.7 && npm cache clean --force;
