FROM buildkite/puppeteer:v1.15.0

USER root

RUN mkdir /usr/src/app && rm -rf /usr/src/app

COPY package* /usr/src/app/
COPY index.js /usr/src/app/

WORKDIR /usr/src/app

RUN npm i && npm cache clean --force;

CMD [ "node", "index.js" ]