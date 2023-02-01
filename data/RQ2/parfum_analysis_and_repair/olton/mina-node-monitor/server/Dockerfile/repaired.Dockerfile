FROM node:14-alpine
MAINTAINER olton "serhii@pimenov.com.ua"
ENV NODE_ENV=production
WORKDIR /minamon
COPY package*.json ./
RUN apk add --no-cache --update openssh-client
RUN npm install --production && npm cache clean --force;
COPY . .
RUN node index --init
EXPOSE 8000
ENTRYPOINT ["node", "index.js"]