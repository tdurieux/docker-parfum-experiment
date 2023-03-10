FROM ubuntu:17.10
LABEL maintainer="Denis Rystsov <rystsov.denis@gmail.com>"
RUN apt-get update -y --fix-missing
RUN apt-get install --no-install-recommends -y wget supervisor iptables && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y iputils-ping vim tmux less curl --fix-missing && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y redis-server && rm -rf /var/lib/apt/lists/*;
WORKDIR /gryadka
COPY gryadka-redis /gryadka/gryadka-redis
COPY redis.conf /gryadka/redis.conf
COPY run-redis.sh /gryadka/run-redis.sh
COPY init-acceptor.sh /gryadka/init-acceptor.sh
COPY node.conf /etc/supervisor/conf.d/node.conf
CMD /usr/bin/supervisord -n
