FROM alpine:3.10
WORKDIR /app
RUN set -xe && \
    apk -U --no-cache add bash git curl wget npm && \
    npm install -g bower && \
    npm install -g gulp && npm cache clean --force;
