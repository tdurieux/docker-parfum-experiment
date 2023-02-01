FROM ubuntu:17.10
LABEL maintainer="Denis Rystsov <rystsov.denis@gmail.com>"
RUN apt-get update -y --fix-missing
RUN apt-get install --no-install-recommends -y wget supervisor iptables && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y iputils-ping vim tmux less curl --fix-missing && rm -rf /var/lib/apt/lists/*;
RUN /bin/bash -c "curl -sL https://deb.nodesource.com/setup_8.x | bash -"
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
WORKDIR /gryadka
COPY gryadka-core /gryadka/gryadka-core
COPY gryadka-redis /gryadka/gryadka-redis
COPY http-proposer /gryadka/http-proposer
WORKDIR /gryadka/http-proposer
RUN npm install && npm cache clean --force;
WORKDIR /gryadka
COPY run-http-proposer.sh /gryadka/run-http-proposer.sh
COPY node.conf /etc/supervisor/conf.d/node.conf
CMD /usr/bin/supervisord -n
