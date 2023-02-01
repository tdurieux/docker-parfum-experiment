ARG NODE_ALPINE_VERSION

FROM node:$NODE_ALPINE_VERSION

# Build Args
ARG NPM_VERSION

RUN npm install -g <package_name >@$NPM_VERSION && npm cache clean --force;
ENTRYPOINT [ "<package_name>" ]