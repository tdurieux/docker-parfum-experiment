FROM node:13-alpine
RUN apk add --no-cache --virtual .gyp \
        python \
        make \
        g++

USER node
WORKDIR /home/node
COPY --chown=node:node package*.json ./
RUN npm install && npm cache clean --force;
COPY --chown=node:node . .
EXPOSE 1337
CMD [ "node", "./app/node.js"]
