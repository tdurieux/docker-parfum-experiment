FROM node:12-alpine

ADD views /app/views
ADD package.json /app
ADD server.js /app

RUN cd /app; npm install && npm cache clean --force;

ENV NODE_ENV production
ENV PORT 8080
EXPOSE 8080

WORKDIR "/app"
CMD [ "npm", "start" ]