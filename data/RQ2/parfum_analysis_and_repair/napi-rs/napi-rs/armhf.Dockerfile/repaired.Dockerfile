FROM multiarch/ubuntu-core:armhf-focal

ARG NODE_VERSION=14

RUN apt-get update && \
  apt-get install --no-install-recommends -y ca-certificates gnupg2 curl apt-transport-https && \
  curl -f -sL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash - && \
  apt-get install --no-install-recommends -y nodejs && \
  npm install -g yarn pnpm && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;
