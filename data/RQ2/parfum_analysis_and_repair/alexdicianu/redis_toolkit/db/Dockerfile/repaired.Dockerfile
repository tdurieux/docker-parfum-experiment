FROM ubuntu:16.04
MAINTAINER Pantheon Systems

RUN apt-get update -y && apt-get install --no-install-recommends redis-server -y && rm -rf /var/lib/apt/lists/*;

ADD redis.conf /etc/
RUN chown redis:redis /etc/redis.conf
RUN chmod 440 /etc/redis.conf

ADD run.sh /
RUN chmod 770 /run.sh

EXPOSE 6379

CMD [ "/run.sh" ]