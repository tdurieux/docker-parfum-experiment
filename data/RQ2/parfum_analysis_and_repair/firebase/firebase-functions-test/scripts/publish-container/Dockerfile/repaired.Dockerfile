FROM node:14

# Install dependencies
RUN apt-get update && \
    apt-get install --no-install-recommends -y curl git jq && rm -rf /var/lib/apt/lists/*;

# Install npm at latest.
RUN npm install --global npm@latest && npm cache clean --force;

# Install hub
RUN curl -fsSL --output hub.tgz https://github.com/github/hub/releases/download/v2.13.0/hub-linux-amd64-2.13.0.tgz
RUN tar --strip-components=2 -C /usr/bin -xf hub.tgz hub-linux-amd64-2.13.0/bin/hub && rm hub.tgz

