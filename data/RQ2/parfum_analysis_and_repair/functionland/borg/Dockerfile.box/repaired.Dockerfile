FROM node:16

COPY ./apps/box /opt/box
WORKDIR /opt/box
RUN mkdir /opt/box/node_modules
COPY ./tools/build-helpers /opt/box/node_modules/build-helpers
RUN npm install && npm cache clean --force;
RUN npm run build
