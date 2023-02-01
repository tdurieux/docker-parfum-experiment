FROM node:alpine
RUN npm i -g @swarthy/wait-for@2.0.2 && npm cache clean --force;
VOLUME /app
WORKDIR /app
USER node
