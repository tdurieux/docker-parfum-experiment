FROM node:14.19-buster

RUN npm install -g @vue/cli && npm cache clean --force;