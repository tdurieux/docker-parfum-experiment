ARG NODE_ALPINE_VERSION

FROM node:$NODE_ALPINE_VERSION

# Build Args
ARG RETIRE_NPM_VERSION

RUN npm install -g retire@$RETIRE_NPM_VERSION && npm cache clean --force;
ENTRYPOINT [ "retire" ]