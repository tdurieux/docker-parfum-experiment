FROM alpine:3.7

RUN apk -U --no-cache add \
  ca-certificates \
  ruby \
  ruby-rdoc \
  ruby-irb \
  && gem install redis


RUN wget https://download.redis.io/redis-stable/src/redis-trib.rb && \
    mv redis-trib.rb /usr/bin/redis-trib && \
    chmod 555 /usr/bin/redis-trib

ENTRYPOINT ["/usr/bin/redis-trib"]
