FROM node:12.14-alpine

WORKDIR /usr/src

COPY package*.json ./
RUN npm ci

CMD ["npm", "run", "start:dev"]