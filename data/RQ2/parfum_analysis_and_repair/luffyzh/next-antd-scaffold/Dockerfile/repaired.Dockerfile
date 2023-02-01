# Dockerfile
# use image
FROM node:8.14 As builder
LABEL maintainer="luffyZh"
COPY . .
# command
RUN yarn install && yarn cache clean;
RUN yarn build
CMD yarn prod
