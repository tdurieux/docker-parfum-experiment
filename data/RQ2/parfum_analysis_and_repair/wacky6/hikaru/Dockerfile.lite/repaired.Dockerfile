FROM node:alpine
LABEL maintainer="Jiewei Qian <qjw@wacky.one>"

ENV HIKARU_DEFAULT_AMQP="amqp://rabbitmq/" \
    HIKARU_DEFAULT_MONGO="mongodb://mongo/hikaru" \
    TZ="Asia/Shanghai" \
    NODE_ENV="production"

USER root
WORKDIR /root/

COPY package.json yarn.lock /hikaru/
COPY uplink/package.json uplink/yarn.lock /hikaru/uplink/
RUN mkdir -p /root/hikaru/ && \
    apk add --no-cache curl ffmpeg tzdata && \
    cp /usr/share/zoneinfo/${TZ} /etc/localtime && \
    echo ${TZ} > /etc/timezone && \
    apk del tzdata && \
    ( cd /hikaru/ ; yarn install ) && \
    yarn cache clean && \
    (cd ~ ; rm -rf .npm .cache .config .gnupg ) && \
    rm -rf /tmp && mkdir /tmp && yarn cache clean;

# TODO: should request docker upstream to support COPY exclusion
COPY bin /hikaru/bin
COPY handlers /hikaru/handlers
COPY lib /hikaru/lib
COPY uplink /hikaru/uplink
COPY modular-support.js LICENSE README.md /hikaru/

ENTRYPOINT ["/hikaru/bin/hikaru"]
