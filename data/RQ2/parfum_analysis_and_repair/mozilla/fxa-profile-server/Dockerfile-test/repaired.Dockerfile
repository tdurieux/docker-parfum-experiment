FROM fxa-profile-server:build
USER root
RUN apk add --repository http://dl-cdn.alpinelinux.org/alpine/v3.5/community/ --no-cache --virtual .build-deps git python make g++
USER app
RUN npm install && npm cache clean --force;
