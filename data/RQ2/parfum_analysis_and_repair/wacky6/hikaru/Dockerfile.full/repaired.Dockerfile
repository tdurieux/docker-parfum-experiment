FROM node:alpine
LABEL maintainer="Jiewei Qian <qjw@wacky.one>"

ENV HIKARU_DEFAULT_AMQP="amqp://rabbitmq/" \
    HIKARU_DEFAULT_MONGO="mongodb://mongo/hikaru" \
    TZ="Asia/Shanghai" \
    NODE_ENV="production"

USER root
WORKDIR /root/

# copy files for node_modules dependencies.
COPY package.json yarn.lock /hikaru/
COPY uplink/package.json uplink/yarn.lock /hikaru/uplink/
COPY posenet/checkpoints.js posenet/package.json posenet/yarn.lock posenet/pose-seg.py /hikaru/posenet/

ARG BUILD_PKGS="build-base ffmpeg-dev git python3 cairo-dev pango-dev \
    tzdata libjpeg-turbo-dev pwgen libc-dev zlib-dev libffi-dev tar gzip"
ARG RUNTIME_PKGS="curl ffmpeg cairo pango libjpeg-turbo \
    python3 py3-scipy py3-numpy py3-scikit-learn py3-matplotlib"

RUN mkdir -p /root/hikaru/ && \
    : Install binary dependencies && \
    apk add --no-cache \
        ${BUILD_PKGS} ${RUNTIME_PKGS} && \
    : Setup Timezone && \
    cp /usr/share/zoneinfo/${TZ} /etc/localtime && \
    echo ${TZ} > /etc/timezone && \
    : Install node dependencies && \
    ( cd /hikaru/ ; yarn install ) && \
    : Delete source maps, esm.js, min.js  && \
    rm -rf $( find \
            -name '*.map' \
        -or -name '*.ts' \
        -or -name '*.esm.js' \
        -or -name '*.min.js' \
        -or -name 'src' \
    ) && \
    : Cleanup temp files and build dependencies && \
    yarn cache clean && \
    apk del ${BUILD_PKGS} && \
    rm -rf /tmp && \
    (cd ~ ; rm -rf .npm .cache .config .gnupg ) && \
    mkdir /tmp

COPY . /hikaru/

ENTRYPOINT ["/hikaru/bin/hikaru"]