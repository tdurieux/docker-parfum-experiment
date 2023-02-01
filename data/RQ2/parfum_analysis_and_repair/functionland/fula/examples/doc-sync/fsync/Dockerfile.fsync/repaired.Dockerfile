FROM node:16
ENV NODE_ENV=production


COPY ./ /opt/fsync
WORKDIR /opt/fsync

RUN npm install && npm cache clean --force;
