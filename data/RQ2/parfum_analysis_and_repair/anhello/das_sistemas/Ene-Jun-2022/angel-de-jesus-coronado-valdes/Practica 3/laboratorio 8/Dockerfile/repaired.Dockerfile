FROM ubuntu:18.04

LABEL maintainer="angel.jaime@example.com"
ENV REFRESHED_AT 2020-11-05

RUN apt-get -yqq update; apt-get -yqq --no-install-recommends install redis-server redis-tools && rm -rf /var/lib/apt/lists/*;

EXPOSE 6379

ENTRYPOINT [ "/usr/bin/redis-server" ]
CMD [ "--protected-mode", "no" ]

