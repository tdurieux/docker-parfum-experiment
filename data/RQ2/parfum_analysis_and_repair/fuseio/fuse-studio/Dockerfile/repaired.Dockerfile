FROM node:12.20.0
USER root

COPY . .

ARG COMMMUNITY_WEB3_PORTIS_ID
ARG COMMUNITY_WEB3_API_KEY
ARG COMMUNITY_WEB3_PROVIDERS_ALCHEMY_ROPSTEN_HTTP
ARG COMMUNITY_WEB3_PROVIDERS_ALCHEMY_MAIN_HTTP
ARG NODE_ENV
ARG NODE_CONFIG_ENV
ARG COMMMUNITY_WEB3_FORTMATIC_ROPSTEN_ID
ARG COMMMUNITY_WEB3_FORTMATIC_MAIN_ID

RUN rm -rf node_modules

RUN cd @fuse/roles && npm install && npm cache clean --force;

RUN cd @fuse/contract-utils && npm install && npm cache clean --force;

RUN export NODE_ENV=qa && cd dapp && npm install && npm run build && cp -r dist/* ../server/public && npm cache clean --force;

RUN cd server && npm install && npm cache clean --force;

RUN cp -r server/* .
RUN ls -lah

CMD [ "npm", "start" ]
