FROM node

ADD . /doorman

RUN \
  cd /doorman && \
  npm install && \
  mv conf.environment.js conf.js && npm cache clean --force;

WORKDIR /doorman

ENTRYPOINT [ "npm", "start" ]
