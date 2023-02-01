FROM node:13

ENV SERVER_BASE=relative
WORKDIR /usr/src/app

COPY package.json package-lock.json ./
RUN npm ci

COPY src/ ./src
COPY dist ./dist
COPY tslint.json tsconfig.json ./

ENTRYPOINT [ "npm", "run" ]