FROM teracy/angular-cli:1.0.0-rc.2

LABEL authors="hoatle <hoatle@teracy.com>"

RUN mkdir -p /opt/app

ENV TERM=xterm APP=/opt/app

# add more arguments from CI to the image so that `$ env` should reveal more info
ARG CI_BUILD_ID
ARG CI_BUILD_REF
ARG CI_REGISTRY_IMAGE
ARG CI_PROJECT_NAME
ARG CI_BUILD_REF_NAME
ARG CI_BUILD_TIME

ENV CI_BUILD_ID=$CI_BUILD_ID CI_BUILD_REF=$CI_BUILD_REF CI_REGISTRY_IMAGE=$CI_REGISTRY_IMAGE \
    CI_PROJECT_NAME=$CI_PROJECT_NAME CI_BUILD_REF_NAME=$CI_BUILD_REF_NAME CI_BUILD_TIME=$CI_BUILD_TIME \
    npm_config_tmp=/tmp

ADD package.json $APP/

WORKDIR $APP

RUN yarn

VOLUME $APP/node_modules
