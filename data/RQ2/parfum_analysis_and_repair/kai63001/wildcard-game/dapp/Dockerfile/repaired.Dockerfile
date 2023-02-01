FROM node:16.14.0-alpine

WORKDIR /dapp
COPY . .

RUN npm install && npm cache clean --force;

CMD ["npm", "run", "dev"]