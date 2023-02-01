FROM ubuntu:12.04.5

MAINTAINER 28msec <hello@28.io>

RUN apt-get update -y
RUN apt-get install --no-install-recommends python-software-properties -y && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:fcavalieri/zorba -y
RUN apt-get update -y
RUN apt-get install --no-install-recommends zorba.* -y && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT ["zorba"]
CMD ["-h"]

VOLUME /queries
WORKDIR /queries
