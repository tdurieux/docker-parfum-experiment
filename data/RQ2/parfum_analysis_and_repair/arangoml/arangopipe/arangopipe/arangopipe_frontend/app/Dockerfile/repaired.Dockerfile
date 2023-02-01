FROM node:8.7.0-alpine

RUN mkdir -p /srv/app/arangoml-ui
WORKDIR /srv/app/arangoml-ui

COPY package.json /srv/app/arangoml-ui

RUN npm install && npm cache clean --force;

COPY . /srv/app/arangoml-ui

CMD ["npm", "start"]