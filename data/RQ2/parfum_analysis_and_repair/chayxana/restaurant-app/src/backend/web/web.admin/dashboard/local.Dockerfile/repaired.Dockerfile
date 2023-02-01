# Stage 1
FROM node:12.18.2-slim as builder
WORKDIR /usr/src/app
COPY package.json ./
RUN yarn
COPY . ./
RUN yarn build --configuration=local-docker --base-href=/dashboard/ --deploy-url=/dashboard/

# Stage 2
#  bitnami/nginx is offers non-root user