## Builder
FROM node:17.9.0-alpine3.15 as builder

WORKDIR /src

COPY package.json package-lock.json /src/
RUN npm ci
COPY . /src/
RUN npm run build


## App