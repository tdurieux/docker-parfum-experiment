FROM ubuntu:18.04
LABEL maintainer="james@example.com"
ENV REFRESHED_AT 2017-06-01

RUN apt-get -qq update
RUN apt-get install -y --no-install-recommends -qq software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:chris-lea/redis-server
RUN apt-get -qq update
RUN apt-get -qq -y --no-install-recommends install redis-server redis-tools && rm -rf /var/lib/apt/lists/*;

VOLUME [ "/var/lib/redis", "/var/log/redis" ]

EXPOSE 6379

CMD []
