FROM node:16-alpine

WORKDIR /usr/src/app/
USER root
COPY package.json .npmrc ./
RUN npm install --production --registry=https://registry.npmmirror.com

COPY ./ ./

EXPOSE 7001

ENTRYPOINT ["npm", "run", "docker-start"]
