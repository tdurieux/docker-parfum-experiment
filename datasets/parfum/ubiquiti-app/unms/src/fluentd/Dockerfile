FROM alpine:3.7

RUN apk update \
 && apk upgrade \
 && apk add --no-cache \
        ca-certificates \
        ruby ruby-irb \
        su-exec \
        dumb-init \
 && apk add --no-cache --virtual .build-deps \
        build-base \
        ruby-dev wget gnupg \
 && update-ca-certificates \
 && echo 'gem: --no-document' >> /etc/gemrc \
 && gem install oj -v 3.3.10 \
 && gem install json -v 2.1.0 \
 && gem install fluentd -v 1.2.3 \
 && fluent-gem install fluent-plugin-multi-format-parser \
 && apk del .build-deps \
 && rm -rf /var/cache/apk/* \
 && rm -rf /tmp/* /var/tmp/* /usr/lib/ruby/gems/*/cache/*.gem

RUN mkdir -p /fluentd/log /fluentd/plugins /etc/fluent

COPY fluent.conf /etc/fluent/
COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

ENV FLUENTD_OPT=""
ENV FLUENTD_CONF="fluent.conf"

ENV LD_PRELOAD=""
ENV DUMB_INIT_SETSID 0

EXPOSE 24224 5140

ENTRYPOINT ["/entrypoint.sh"]

CMD fluentd -c /etc/fluent/${FLUENTD_CONF} -p /fluentd/plugins $FLUENTD_OPT
