# Build the React frontend
FROM node:16-alpine as build-step

WORKDIR /app

COPY ./frontend/package.json ./frontend/yarn.lock ./
COPY ./frontend/src ./src
COPY ./frontend/public ./public

RUN yarn install && yarn cache clean;
RUN yarn build

# The node image is no longer needed, so start afresh with the smaller nginx image
FROM nginx:stable-alpine

COPY --from=build-step /app/src/game /game
COPY --from=build-step /app/build /usr/share/nginx/html
COPY /default.conf /etc/nginx/conf.d/default.conf