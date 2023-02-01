# latest node has issue: https://github.com/Azure/static-web-apps/issues/231

# build the website
FROM node:14 as donator
COPY . /data
WORKDIR /data
RUN npm ci
RUN npm run lint
RUN npm run build:staging

# deploy to an nginx