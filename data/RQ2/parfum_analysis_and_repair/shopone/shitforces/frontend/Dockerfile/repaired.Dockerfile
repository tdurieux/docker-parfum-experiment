FROM node:14.16.0
RUN npm install -g npm && npm cache clean --force;
