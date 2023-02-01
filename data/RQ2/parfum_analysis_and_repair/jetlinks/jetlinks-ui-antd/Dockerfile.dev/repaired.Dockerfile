FROM node:latest

WORKDIR /usr/src/app/

COPY package.json ./
RUN npm install --silent --no-cache --registry=https://registry.npm.taobao.org && npm cache clean --force;

COPY ./ ./

RUN npm run fetch:blocks

CMD ["npm", "run", "start"]
