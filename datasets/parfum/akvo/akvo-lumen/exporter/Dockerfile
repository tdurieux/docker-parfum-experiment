FROM buildkite/puppeteer:v1.15.0

USER root

RUN mkdir /usr/src/app

COPY package* /usr/src/app/
COPY index.js /usr/src/app/

WORKDIR /usr/src/app

RUN npm i

CMD [ "node", "index.js" ]