FROM node:16-alpine

WORKDIR /action

COPY package.json /action/package.json
RUN npm install && npm cache clean --force;

COPY . /action

ENTRYPOINT [ "node", "/action/action.js" ]
