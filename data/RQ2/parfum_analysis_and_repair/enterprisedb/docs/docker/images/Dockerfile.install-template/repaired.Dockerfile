FROM node:14-alpine as base

RUN npm install -g npm@7 && npm cache clean --force;
WORKDIR /app


FROM base as dependencies

COPY install_template/package*.json ./
RUN npm i && npm cache clean --force;


FROM base as renderer

COPY --from=dependencies /app/node_modules /app/node_modules
