FROM node:8-alpine

EXPOSE 3000

COPY . /slack-invite-automation
WORKDIR /slack-invite-automation

RUN npm install && npm cache clean --force;

CMD node ./bin/www
