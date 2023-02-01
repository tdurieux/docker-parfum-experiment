FROM node:16.13.0 as base
MAINTAINER team pallete:tadaktadak

RUN mkdir -p /app
WORKDIR /app
ADD ./ /app
RUN npm install && npm cache clean --force;
ENV NODE_ENV=production
RUN npm run build
CMD node dist/main.js