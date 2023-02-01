FROM node:12.6.0

RUN env

COPY package.json /opt/app/
COPY yarn.lock /opt/app/
COPY lerna.json /opt/app/
COPY ws-fixer.sh /opt/app/
COPY packages /opt/app/packages/
WORKDIR /opt/app

RUN yarn install --loglevel=warn --unsafe-perm
RUN yarn lerna bootstrap
# RUN yarn packages/clean
RUN yarn packages/build

EXPOSE ${PORT:-80}
