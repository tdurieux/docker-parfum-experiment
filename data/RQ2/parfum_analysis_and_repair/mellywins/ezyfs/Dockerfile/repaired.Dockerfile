FROM node:14.16.1-alpine3.11 As development

LABEL maintainer="oussama.zouaghi@insat.ucar.tn"

WORKDIR /usr/src/app

COPY package.json ./

RUN npm install && npm cache clean --force;

COPY . .

RUN npm run build



FROM node:14.16.1-alpine3.11 as production

LABEL maintainer="oussama.zouaghi@insat.ucar.tn"
ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install --only=production && npm cache clean --force;

COPY . .


COPY --from=development /usr/src/app/dist ./dist

ENTRYPOINT [ "npm","run","start:prod" ]