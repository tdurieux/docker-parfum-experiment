FROM node:14-alpine
MAINTAINER olton "serhii@pimenov.com.ua"
WORKDIR /minamon
COPY package*.json ./
RUN mkdir output
RUN npm install && npm cache clean --force;
COPY . .
EXPOSE 2222
ENTRYPOINT ["node", "start.js"]