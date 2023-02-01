FROM node:13.13.0-alpine

RUN npm install -g newman newman-reporter-html && npm cache clean --force;

WORKDIR /etc/newman

ENTRYPOINT ["newman"]
