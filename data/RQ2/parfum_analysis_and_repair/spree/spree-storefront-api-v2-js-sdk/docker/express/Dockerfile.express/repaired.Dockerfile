FROM spree/test-runtime

FROM node:14.15.4

COPY --from=0 /sdk /sdk

WORKDIR /app

COPY ./docker/express /app

RUN npm install && npm cache clean --force;

ENTRYPOINT ./express-docker-entrypoint.sh
