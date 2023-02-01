FROM node:lts-alpine as build-front

RUN apk add --no-cache curl

WORKDIR /app

COPY ./client .

RUN npm install --production \
    && npm run build && npm cache clean --force;

FROM node:lts-alpine

WORKDIR /app

RUN mkdir -p ./public

COPY --from=build-front /app/build/ ./public

COPY package*.json ./

RUN npm install && npm cache clean --force;

COPY . .

CMD ["npm", "run", "skaffold"]