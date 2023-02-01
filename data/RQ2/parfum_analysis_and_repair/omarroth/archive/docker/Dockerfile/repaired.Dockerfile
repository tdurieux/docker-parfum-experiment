FROM node:10

RUN git clone https://github.com/omarroth/archive.git /archive

WORKDIR /archive/node
RUN npm install && npm cache clean --force;
WORKDIR /archive/node/worker

CMD ["node", "index.js"]
