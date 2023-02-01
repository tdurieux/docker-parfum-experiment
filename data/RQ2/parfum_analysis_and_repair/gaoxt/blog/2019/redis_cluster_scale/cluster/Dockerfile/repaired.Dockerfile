FROM redis:5-alpine
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
RUN apk --no-cache add gettext
RUN mkdir /redis-conf && mkdir /redis-data && mkdir /redis-logs
COPY redis.tmpl /etc/redis/redis.tmpl
COPY cluster-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/cluster-entrypoint.sh
EXPOSE 7000 7001
ENTRYPOINT ["cluster-entrypoint.sh"]