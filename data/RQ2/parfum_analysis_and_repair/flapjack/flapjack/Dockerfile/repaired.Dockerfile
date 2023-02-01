FROM stackbrew/ubuntu:trusty

RUN apt-get install --no-install-recommends -y gnupg && rm -rf /var/lib/apt/lists/*;

RUN gpg --batch --keyserver keys.gnupg.net --recv-keys 803709B6
RUN gpg --batch -a --export 803709B6 | apt-key add -

RUN echo "deb http://packages.flapjack.io/deb/v1 trusty main" | tee /etc/apt/sources.list.d/flapjack.list
RUN apt-get update
RUN apt-cache policy flapjack
RUN apt-get install --no-install-recommends -y flapjack && rm -rf /var/lib/apt/lists/*;

EXPOSE 3080 3081 3071 6380

CMD /etc/init.d/redis-flapjack start && /opt/flapjack/bin/flapjack server start --no-daemonize

