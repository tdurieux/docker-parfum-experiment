FROM ${DOCKER_PREFIX}env:${PORTAL_ENV_TAG}${BUILD_ALPINE}

USER root

RUN npm install -g mocha && npm cache clean --force;
