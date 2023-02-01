FROM debian:unstable

MAINTAINER Clint Ruoho clint@wtfismyip.com

RUN apt-get -y update && apt-get -y --no-install-recommends install redis procps && rm -rf /var/lib/apt/lists/*;

WORKDIR /app
ADD . /app
USER redis
CMD [ "bash", "redis.sh" ]
