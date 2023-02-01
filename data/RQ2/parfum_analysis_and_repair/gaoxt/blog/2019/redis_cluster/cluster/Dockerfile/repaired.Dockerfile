FROM redis:5-alpine
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
RUN apk --no-cache add gettext
RUN mkdir /redis-conf && mkdir /redis-data && mkdir /redis-logs
COPY redis.tmpl /redis-conf/redis.tmpl

# Add startup script
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod 755 /docker-entrypoint.sh

EXPOSE 7000 7001 7002 7003 7004 7005 7006 7007
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["redis-cluster"]