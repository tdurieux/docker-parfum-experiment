FROM node:12

WORKDIR /usr/src/app

COPY package.json .
COPY package-lock.json .

ARG NPM_CONFIG_REGISTRY=https://registry.npmjs.org/

RUN npm install && npm cache clean --force;

COPY . .

EXPOSE 3000

CMD ["npm", "start"]
