FROM node:16.14.0

WORKDIR /app
RUN yarn global add serve && yarn cache clean;
COPY build /app
