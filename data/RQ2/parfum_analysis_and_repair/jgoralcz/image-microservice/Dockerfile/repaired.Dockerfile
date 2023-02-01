FROM joshgor01/ubuntu_node_opencv:latest

RUN groupadd --gid 1000 node \
  && useradd --uid 1000 --gid node --shell /bin/bash --create-home node

COPY --chown=node:node assets/ /usr/node/assets
COPY --chown=node:node package*.json /usr/node/

WORKDIR /usr/node

RUN mkdir logs && chown -R node:node logs

RUN apt-get install --no-install-recommends autoconf -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends dh-autoreconf -y && rm -rf /var/lib/apt/lists/*;

RUN npm install opencv && npm cache clean --force;
RUN npm install sharp@0.28.3 && npm cache clean --force;
RUN npm install canvas@2.6.1 && npm cache clean --force;
RUN npm install gifencoder && npm install gif-encoder-2 && npm install gif-frames && npm cache clean --force;
RUN npm install smartcrop-gm && npm install gm && npm cache clean --force;
RUN npm install git+https://github.com/jgoralcz/gif-resize.git && npm cache clean --force;

RUN npm install && npm cache clean --force;

COPY --chown=node:node config.json /usr/node/
COPY --chown=node:node src/ /usr/node/src/

WORKDIR /usr/node/src
USER node

EXPOSE 8443

CMD ["npm", "start"]



