FROM node:carbon

MAINTAINER Sukchan Lee <acetcom@gmail.com>

ARG PACKAGE=open5gs
ARG VERSION=2.2.6

RUN set -e; \
    cd /usr/src; \
    rm -rf ./$PACKAGE; \
    curl -f -SLO "https://github.com/open5gs/$PACKAGE/archive/v$VERSION.tar.gz"; \
    tar -xvf v$VERSION.tar.gz; rm v$VERSION.tar.gz \
    mv ./$PACKAGE-$VERSION/ ./$PACKAGE;

WORKDIR /usr/src/open5gs/webui
RUN npm install && \
    npm run build && npm cache clean --force;

CMD npm run start

EXPOSE 3000
