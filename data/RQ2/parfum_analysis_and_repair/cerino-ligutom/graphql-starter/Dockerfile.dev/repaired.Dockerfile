# https://github.com/nodejs/docker-node/blob/master/docs/BestPractices.md

FROM node:16-alpine

EXPOSE 8080

WORKDIR /usr/src/app

COPY package*.json ./
COPY patches ./patches
RUN npm install && npm cache clean --force;

# Copy files from host to container
COPY ./ ./

RUN npm run build

RUN ls -al

CMD [ "npm", "start" ]
