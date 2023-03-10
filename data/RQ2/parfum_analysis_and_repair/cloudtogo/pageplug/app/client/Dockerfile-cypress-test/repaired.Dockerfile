# FROM cypress/browsers:node10.16.3-chrome80-ff73
FROM nginx:1.17.9-alpine

RUN apt update -y -q && \
    apt-get install --no-install-recommends -y -q nginx gettext-base && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    yarn global add serve
