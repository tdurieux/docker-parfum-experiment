FROM ubuntu:18.04
LABEL maintainer="james@example.com"
ENV REFRESHED_AT 2014-06-01

RUN apt-get -qq update && apt-get -qq -y --no-install-recommends install redis-server redis-tools && rm -rf /var/lib/apt/lists/*;

EXPOSE 6379

ENTRYPOINT ["/usr/bin/redis-server" ]
CMD []
