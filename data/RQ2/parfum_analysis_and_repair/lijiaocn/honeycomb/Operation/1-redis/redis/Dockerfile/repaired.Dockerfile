#
# Redis Dockerfile
#
# https://github.com/dockerfile/redis
#

# Pull base image.
FROM base-os:1.0

# Install Redis.
RUN \
  cd /tmp && \
  # Modify to stay at this version rather then always update.

  #################################################################
  ###################### REDIS INSTALL ############################
  wget https://download.redis.io/releases/redis-2.8.19.tar.gz && \
  tar xvzf redis-2.8.19.tar.gz && \
  cd redis-2.8.19 && \
  ################################################################
  ################################################################
  make && \
  make install && \
  cp -f src/redis-sentinel /usr/local/bin && \
  mkdir -p /etc/redis && \
  cp -f *.conf /etc/redis && \
  rm -rf /tmp/redis-stable* && \
  sed -i 's/^\(bind .*\)$/# \1/' /etc/redis/redis.conf && \
  sed -i 's/^\(daemonize .*\)$/# \1/' /etc/redis/redis.conf && \
  sed -i 's/^\(dir .*\)$/# \1\ndir \/data/' /etc/redis/redis.conf && \
  sed -i 's/^\(logfile .*\)$/# \1/' /etc/redis/redis.conf && rm redis-2.8.19.tar.gz

# Define mountable directories.
VOLUME ["/data"]

# Define working directory.
WORKDIR /data

ADD etc_redis_redis.conf /etc/redis/redis.conf

# Print redis configs and start.
# CMD "redis-server /etc/redis/redis.conf"

# Expose ports.
EXPOSE 6379
