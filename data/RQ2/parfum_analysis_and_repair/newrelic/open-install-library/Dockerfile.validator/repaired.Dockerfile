FROM node:14.9-alpine

WORKDIR /opt/local/newrelic

ADD validator validator

WORKDIR /opt/local/newrelic/validator

RUN npm install && npm cache clean --force;

CMD ["npm", "run", "check"]
