FROM        ubuntu
RUN apt-get update && apt-get install --no-install-recommends -y software-properties-common python-software-properties && rm -rf /var/lib/apt/lists/*;
RUN         /usr/bin/add-apt-repository ppa:chris-lea/redis-server
RUN         apt-get update
RUN apt-get -y --no-install-recommends --force-yes install redis-server && rm -rf /var/lib/apt/lists/*;
ADD	    redis-server.sh /usr/bin/
ENTRYPOINT  ["/usr/bin/redis-server.sh"]
