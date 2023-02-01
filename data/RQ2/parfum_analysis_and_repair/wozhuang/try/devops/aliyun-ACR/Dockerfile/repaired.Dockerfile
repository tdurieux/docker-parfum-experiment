FROM node:16-alpine

WORKDIR /usr/src/app/
USER root
COPY package.json .npmrc ./
RUN npm install --production --registry=https://registry.npmmirror.com && npm cache clean --force;

COPY ./ ./

EXPOSE 7001

ENTRYPOINT ["npm", "run", "docker-start"]
