FROM ubuntu:14.04
LABEL maintainer James Turnbull "james@example.com"
ENV REFRESHED_AT 2014-06-01
RUN apt-get update && apt-get --no-install-recommends install -y redis-server redis-tools && rm -rf /var/lib/apt/lists/*;
EXPOSE 6379
ENTRYPOINT [ "/usr/bin/redis-server" ]
