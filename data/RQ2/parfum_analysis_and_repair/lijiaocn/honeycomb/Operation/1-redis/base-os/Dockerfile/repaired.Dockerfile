#
# Redis Dockerfile
#
# https://github.com/dockerfile/redis
#

# Pull base image.
FROM ubuntu

# Install Redis.
RUN \
  cd /tmp && \
  # Modify to stay at this version rather then always update.

  #################################################################
  ###################### REDIS INSTALL ############################
  apt-get update && \
  apt-get install --no-install-recommends -y libc -d \
  apt-get install --no-install-recommends -y wget && \
  apt-get install --no-install-recommends -y mak && rm -rf /var/lib/apt/lists/*;

# Define mountable directories.
VOLUME ["/data"]

# Define working directory.
WORKDIR /data


# Print redis configs and start.
# CMD "redis-server /etc/redis/redis.conf"

# Expose ports.
EXPOSE 6379
