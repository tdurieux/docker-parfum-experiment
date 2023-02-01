FROM node:11.15.0

# https://github.com/Automattic/node-canvas#compiling
RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        build-essential \
        libcairo2-dev \
        libpango1.0-dev \
        libjpeg-dev \
        libgif-dev \
        librsvg2-dev && rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/src/ocim-frontend
COPY ./ /usr/src/ocim-frontend

# Move node_modules out of the source path
RUN npm install -g --unsafe-perm && npm cache clean --force;

CMD [ "npm", "start" ]