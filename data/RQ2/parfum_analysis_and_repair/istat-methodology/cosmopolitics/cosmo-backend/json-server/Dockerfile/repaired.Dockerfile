FROM node:alpine

ARG DOCKER_TAG
ENV APP_VERSION=$DOCKER_TAG
RUN echo "Bulding Docker image version: $APP_VERSION"

COPY . /app
WORKDIR /app

RUN npm install && npm cache clean --force;
CMD ["node", "/app/server.js"]
