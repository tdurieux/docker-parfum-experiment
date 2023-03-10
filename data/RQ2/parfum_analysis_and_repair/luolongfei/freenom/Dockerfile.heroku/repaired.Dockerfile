FROM php:7.4.19-alpine3.13

LABEL author="mybsdc <mybsdc@gmail.com>" \
    maintainer="luolongfei <luolongf@gmail.com>"

ENV TZ Asia/Shanghai
ENV IS_HEROKU 1

WORKDIR /app

COPY . ./

COPY ./heroku/nginx.template.conf ./
COPY ./heroku/html ./html/

RUN set -eux \
    && apk update \
    && apk add --no-cache tzdata bash nginx gettext

COPY ./heroku/startup.sh /
RUN chmod +x /startup.sh

# https://devcenter.heroku.com/articles/container-registry-and-runtime#dockerfile-commands-and-runtime
CMD ["/bin/bash", "-c", "/startup.sh"]