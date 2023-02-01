FROM ruby:latest
MAINTAINER David Yip <yipdw@member.fsf.org>

RUN apt-get -yqq update && apt-get -yqq dist-upgrade

# plumbing needs ZeroMQ
RUN apt-get install --no-install-recommends -yqq libzmq3-dev && rm -rf /var/lib/apt/lists/*;

# useful diagnostic tools for when stuff goes wrong
RUN apt-get install --no-install-recommends -yqq vim git traceroute jq && rm -rf /var/lib/apt/lists/*;

RUN adduser --home /home/archivebot --shell /bin/bash \
	--uid 1000 archivebot --quiet --disabled-password

VOLUME /home/archivebot/ArchiveBot

USER archivebot
WORKDIR /home/archivebot/ArchiveBot
