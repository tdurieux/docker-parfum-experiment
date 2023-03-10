FROM runnable/base:1.0.0

# Install Redis 3.0

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN groupadd -r redis && useradd -r -g redis redis

ENV REDIS_VERSION 3.0.7
ENV REDIS_DOWNLOAD_URL http://download.redis.io/releases/redis-3.0.7.tar.gz
ENV REDIS_DOWNLOAD_SHA1 e56b4b7e033ae8dbf311f9191cf6fdf3ae974d1c

# for redis-sentinel see: http://redis.io/topics/sentinel
RUN buildDeps='gcc libc6-dev make' \
  && set -x \
  && apt-get update && apt-get install -y $buildDeps --no-install-recommends \
  && rm -rf /var/lib/apt/lists/* \
  && wget -O redis.tar.gz "$REDIS_DOWNLOAD_URL" \
  && echo "$REDIS_DOWNLOAD_SHA1 *redis.tar.gz" | sha1sum -c - \
  && mkdir -p /usr/src/redis \
  && tar -xzf redis.tar.gz -C /usr/src/redis --strip-components=1 \
  && rm redis.tar.gz \
  && make -C /usr/src/redis \
  && make -C /usr/src/redis install \
  && rm -r /usr/src/redis \
  && apt-get purge -y --auto-remove $buildDeps

RUN mkdir /data && chown redis:redis /data

WORKDIR /data

EXPOSE 6379
CMD gosu redis redis-server