FROM node:11.4.0 as build-stage

WORKDIR /app
COPY package.json .
COPY package-lock.json .
RUN npm install && npm cache clean --force;
COPY . /app
RUN /app/node_modules/.bin/tsc --build /app/tsconfig.json

FROM keymetrics/pm2:12-alpine
LABEL maintainer "Dan Melton <dan@civicsoftwarefoundation.org>"

WORKDIR /app
COPY --from=build-stage /app/models/seeds/ /app/models/seeds
COPY --from=build-stage /app/build/ /app/build/
COPY --from=build-stage /app/node_modules/ /app/node_modules/
COPY --from=build-stage /app/pm2.json /app/pm2.json

RUN apk add --no-cache curl


EXPOSE 3000
CMD [ "pm2-runtime", "start", "/app/pm2.json" ]
