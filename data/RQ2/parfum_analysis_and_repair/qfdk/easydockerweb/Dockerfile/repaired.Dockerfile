FROM node:9-alpine
ADD . /src

RUN apk update && apk add --no-cache bash && \
    cd /src; yarn install && \
    # Time zone option, if you live in China pleace set it to Asia/Shanghai
    ln -sf /usr/share/zoneinfo/Europe/Paris /etc/localtime && yarn cache clean;

EXPOSE  3000
CMD node /src/bin/www
