FROM ubuntu:17.10
LABEL maintainer="Denis Rystsov <rystsov.denis@gmail.com>"
RUN apt-get update -y
RUN apt-get install --no-install-recommends -y wget supervisor iptables && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y iputils-ping vim tmux less curl && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y redis-server && rm -rf /var/lib/apt/lists/*;
RUN /bin/bash -c "curl -sL https://deb.nodesource.com/setup_8.x | bash -"
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /gryadka
WORKDIR /gryadka
COPY isolate.sh /gryadka/isolate.sh
COPY rejoin.sh /gryadka/rejoin.sh
COPY redis.conf /gryadka/redis.conf
COPY run-redis.sh /gryadka/run-redis.sh
COPY remote-tester /gryadka/remote-tester
WORKDIR /gryadka/remote-tester
RUN npm install && npm cache clean --force;
WORKDIR /gryadka
COPY cluster.json /gryadka/cluster.json
COPY run-gryadka.sh /gryadka/run-gryadka.sh
COPY gryadka.conf /etc/supervisor/conf.d/gryadka.conf
CMD /usr/bin/supervisord -n
