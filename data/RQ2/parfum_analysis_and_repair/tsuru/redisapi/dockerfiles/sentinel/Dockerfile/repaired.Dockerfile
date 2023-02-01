FROM        ubuntu
EXPOSE      26379
RUN apt-get update && apt-get install --no-install-recommends -y software-properties-common python-software-properties && rm -rf /var/lib/apt/lists/*;
RUN         /usr/bin/add-apt-repository ppa:chris-lea/redis-server
RUN         apt-get update
RUN apt-get -y --no-install-recommends --force-yes install redis-server && rm -rf /var/lib/apt/lists/*;
RUN         touch /tmp/sentinel.conf
CMD         ["/tmp/sentinel.conf","--sentinel","--port 26379","--loglevel warning"]
ENTRYPOINT  ["/usr/bin/redis-server"]
