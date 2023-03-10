FROM node:16-alpine

ARG SERVICE_PORT
ENV SERVICE_PORT=${SERVICE_PORT}

EXPOSE ${SERVICE_PORT}

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install && npm cache clean --force;
COPY . .

CMD ["node", "index.js"]
