ARG INSTANA_LAYER=icr.io/instana/google-cloud-run-nodejs:latest
ARG NODEJS_VERSION=12.16.3

FROM ${INSTANA_LAYER} as instanaLayer

FROM node:${NODEJS_VERSION}
WORKDIR /usr/src/app

COPY package*.json ./
RUN npm install --only=production && npm cache clean --force;

COPY . .

COPY --from=instanaLayer /instana /instana
RUN /instana/setup.sh
ENV NODE_OPTIONS="--require /instana/node_modules/@instana/google-cloud-run"

EXPOSE 4816

ENTRYPOINT [ "npm", "start" ]
