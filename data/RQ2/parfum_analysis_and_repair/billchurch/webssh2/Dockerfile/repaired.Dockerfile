FROM node:16-alpine

WORKDIR /usr/src
COPY app/ /usr/src/
RUN npm install --production && npm cache clean --force;
EXPOSE 2222/tcp
ENTRYPOINT [ "/usr/local/bin/node", "index.js" ]
