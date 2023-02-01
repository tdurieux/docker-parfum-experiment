# make sure context is the root of the whole repo!
FROM node:12-buster AS build
WORKDIR /app
COPY ./package-lock.json /app
COPY ./package.json /app
COPY ./decorate-angular-cli.js /app
RUN ["npm","install","--unsafe-perm"]
COPY . /app
RUN ["npx","nx","build","core","--prod"]
RUN ["npx","nx","build","node-backend","--prod"]

FROM node:12-alpine AS final
WORKDIR /app
# backend packages only