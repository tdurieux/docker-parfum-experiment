FROM statemood/alpine:edge

RUN apk update                 && \
     apk upgrade && \
     apk add --no-cache "nodejs~=8.12.0" && \
     apk add --no-cache "npm~=8.12.0" && \
     cd /usr/lib && npm i cross-env && npm cache clean --force;