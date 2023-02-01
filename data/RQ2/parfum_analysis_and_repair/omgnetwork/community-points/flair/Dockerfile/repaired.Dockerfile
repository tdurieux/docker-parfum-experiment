FROM node:12-alpine

RUN apk update && apk add --no-cache python g++ make

WORKDIR /app

COPY . .

RUN npm install && npm cache clean --force;

ENTRYPOINT ["npm", "start"]