FROM node:current-alpine
LABEL author="Patrick Gryzan <pgryzan@hashicorp.io>"
LABEL description="This the web client piece of an example node.js application"

RUN apk --no-cache add curl

RUN mkdir -p /app/node_modules && chown -R node:node /app

WORKDIR /app

COPY package*.json ./

USER node

RUN npm install && npm cache clean --force;

COPY --chown=node:node . .

EXPOSE 3000

CMD ["npm", "start" ]