FROM ubuntu:16.04

MAINTAINER lxerxa <actionview@126.com>

RUN apt-get update && \
    apt-get -yq --no-install-recommends install \
        netcat-openbsd \
        mongodb && rm -rf /var/lib/apt/lists/*;

RUN touch /.initdb

ADD dbdata /dbdata

ADD scripts /scripts
RUN chmod a+x /scripts/*.sh

EXPOSE 27017

VOLUME ["/data"]

CMD ["/scripts/run.sh"]
