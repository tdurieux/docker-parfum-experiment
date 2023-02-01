FROM fluent/fluentd:v0.12-onbuild
MAINTAINER YOUR_NAME <...@...>

USER root

RUN apk add --no-cache --update --virtual .build-deps \
        sudo build-base ruby-dev \

 # cutomize following instruction as you wish
 && sudo -u fluent gem install \
        fluent-plugin-secure-forward \

 && sudo -u fluent gem sources --clear-all \
 && apk del .build-deps \
 && rm -rf /home/fluent/.gem/ruby/2.3.0/cache/*.gem

USER fluent

EXPOSE 24284
