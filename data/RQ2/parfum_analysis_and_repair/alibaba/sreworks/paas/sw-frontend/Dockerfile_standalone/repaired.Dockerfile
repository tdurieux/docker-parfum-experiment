FROM node:10-alpine AS build
COPY . /app
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    && apk add --update --no-cache python2 make gcc g++ zip
RUN /bin/sh /app/sbin/build-standalone.sh

FROM alpine:latest AS release
COPY ./APP-META-PRIVATE/deploy-config/config.js.tpl /app/config.js.tpl
COPY ./APP-META-PRIVATE/deploy-config/ /app/deploy-config/
COPY ./sbin/ /app/sbin/
RUN chmod -R +x /app/sbin/
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    && apk add --update --no-cache curl vim bash gettext sudo wget libc6-compat nginx zip

COPY --from=build /app/build.zip /app/build.zip
RUN cd /app && unzip build.zip && rm -rf build.zip 
ENTRYPOINT ["/app/sbin/run.sh"]