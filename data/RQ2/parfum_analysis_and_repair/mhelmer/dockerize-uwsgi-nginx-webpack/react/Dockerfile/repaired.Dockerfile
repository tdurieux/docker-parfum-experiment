FROM node:6-alpine

RUN npm install --quiet -g webpack && npm cache clean --force;

COPY src/package.json /srv/react/

WORKDIR /srv/react
RUN chown -R node:node .
USER node

RUN yarn install --quiet && yarn cache clean;
COPY src /srv/react
USER root
RUN chown -R node:node .
USER node

RUN webpack

CMD [ "npm", "start" ]
