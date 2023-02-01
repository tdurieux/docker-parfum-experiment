FROM node:8-alpine
LABEL maintainer="atoepfer87@gmail.com"

WORKDIR /fitjunction
ADD package.json package-lock.json ./
RUN npm install && npm cache clean --force;
ADD . ./

CMD node main.js notinteractive
EXPOSE 80
