FROM node:15-alpine AS build

COPY . /app

WORKDIR /app

RUN npm i --only=prod && npm cache clean --force;

FROM node:15-alpine

COPY --from=build /app /app

USER node

CMD ["node", "/app/index.js"]
