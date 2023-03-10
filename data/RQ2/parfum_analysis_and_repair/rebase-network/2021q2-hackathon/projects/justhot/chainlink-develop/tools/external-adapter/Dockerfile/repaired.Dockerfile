FROM node:12.18.4-alpine

ARG SRCROOT=/usr/local/src/chainlink
WORKDIR ${SRCROOT}
COPY yarn.lock package.json .yarnrc tsconfig.cjs.json ./
COPY .yarn .yarn
COPY tools/external-adapter/package.json tools/external-adapter/

# install deps for our integration scripts
RUN yarn

# copy over all our dependencies
COPY tools/external-adapter tools/external-adapter

# setup project
RUN yarn workspace @chainlink/external-adapter setup && yarn cache clean;

ENV EXTERNAL_ADAPTER_PORT 6644
EXPOSE 6644

ENTRYPOINT [ "yarn", "workspace", "@chainlink/external-adapter", "start" ]
