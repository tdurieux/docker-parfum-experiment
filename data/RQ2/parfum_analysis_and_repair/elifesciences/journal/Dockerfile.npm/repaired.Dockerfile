ARG node_version
FROM node:${node_version} as npm

RUN apt-get update && apt-get install --no-install-recommends -y \
    nasm \
    libvips-dev \
    && rm -rf /var/lib/apt/lists/*

COPY npm-shrinkwrap.json \
    package.json \
    ./

RUN npm install && npm cache clean --force;
