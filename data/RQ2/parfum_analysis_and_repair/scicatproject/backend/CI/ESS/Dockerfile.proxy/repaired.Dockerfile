# gives a docker image below 200 MB
FROM node:16-alpine

ENV NODE_ENV "production"
ENV PORT 3000
EXPOSE 3000

ENV http_proxy "http://192.168.1.1:8123"
ENV https_proxy $http_proxy
ENV no_proxy "localhost, 127.0.0.1"
RUN apk update && apk upgrade && \
    apk add --no-cache git

# Prepare app directory
WORKDIR /home/node/app
COPY package*.json /home/node/app/
COPY .snyk /home/node/app/

# set up local user to avoid running as root
RUN chown -R node:node /home/node/app
USER node

# Install our packages
RUN npm config set proxy  $http_proxy
RUN npm config set https-proxy  $http_proxy
RUN npm config set registry http://registry.npmjs.org/
RUN npm config set strict-ssl false
RUN npm ci --only=production


# Copy the rest of our application, node_modules is ignored via .dockerignore
COPY --chown=node:node . /home/node/app
COPY --chown=node:node CI/ESS/envfiles/config.ess.js /home/node/app/server/config.local.js
#COPY CI/ESS/envfiles/middleware.json /usr/src/app/server/middleware.json
COPY --chown=node:node CI/ESS/envfiles/providers.json /home/node/app/server/providers.json
COPY --chown=node:node CI/ESS/envfiles/datasources.json /home/node/app/server/datasources.json
#COPY CI/ESS/envfiles/component-config.json /usr/src/app/server/
#COPY CI/ESS/start.sh /usr/src/app/start.sh
#COPY CI/ESS/settings.json /usr/src/app/test/config/

# Start the app
ENV http_proxy=
ENV https_proxy=
ENV no_proxy=
ENV http_proxy "http://172.18.12.30:8123"
ENV https_proxy $http_proxy
ENV no_proxy "localhost, 127.0.0.1"
# RUN npm config set proxy  $http_proxy
# RUN npm config set https-proxy  $http_proxy