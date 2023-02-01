FROM node:10-slim

RUN apt-get update \
    && apt-get install --no-install-recommends -y git openssh-client libpng-dev \
    && npm --version \
    && npm install -g hexo-cli && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;

WORKDIR /home/node/blog
