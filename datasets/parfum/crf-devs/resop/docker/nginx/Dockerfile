FROM alpine:3.9 AS withoutsources

RUN apk add --update --no-cache \
    nginx \
    curl \
  && rm -rf /var/cache/apk/* && rm -rf /tmp/*

COPY ./docker/nginx/files/. /

RUN echo "daemon off;" >> /etc/nginx/nginx.conf

ENV FPM_ENDPOINT "fpm:9000"

WORKDIR /srv

ENTRYPOINT ["/bin/entrypoint"]
CMD ["nginx"]

EXPOSE 80

HEALTHCHECK --interval=5s --timeout=5s --start-period=5s --retries=3 CMD curl -s http://0.0.0.0/health 1>/dev/null || exit 1
STOPSIGNAL SIGQUIT

# ================================================

FROM withoutsources AS withsources

COPY ./public/. /srv/public

CMD ["nginx"]
