FROM supermy/alpine

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN addgroup -S redis && adduser -S -G redis redis

# grab su-exec for easy step-down from root
RUN apk add --no-cache 'su-exec>=0.2'

#http://download.redis.io/releases/redis-3.2.6.tar.gz

ENV REDIS_VERSION 3.2.6
ENV REDIS_DOWNLOAD_URL http://download.redis.io/releases/redis-3.2.6.tar.gz
ENV REDIS_DOWNLOAD_SHA1 92d6d93ef2efc91e595c8bf578bf72baff397507

# for redis-sentinel see: http://redis.io/topics/sentinel
RUN set -x \
	&& apk add --no-cache --virtual .build-deps \
		gcc \
		linux-headers \
		make \
		musl-dev \
		tar \
	&& wget -O redis.tar.gz "$REDIS_DOWNLOAD_URL" \
	#&& echo "$REDIS_DOWNLOAD_SHA1 *redis.tar.gz" | sha1sum -c - \
	&& mkdir -p /usr/src/redis \
	&& tar -xzf redis.tar.gz -C /usr/src/redis --strip-components=1 \
	&& rm redis.tar.gz \
	&& make -C /usr/src/redis \
	&& make -C /usr/src/redis install \
	&& rm -r /usr/src/redis \
	&& apk del .build-deps

RUN mkdir /data && chown redis:redis /data
VOLUME /data
WORKDIR /data

COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod a+x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

EXPOSE 6379
CMD [ "redis-server" ]
#CMD [ "redis-server", "/usr/local/etc/redis/redis.conf" ]