FROM docker-dev.yelpcorp.com/xenial_yelp
MAINTAINER John Billings <billings@yelp.com>

RUN apt-get update && \
    apt-get install -y --no-install-recommends software-properties-common

RUN apt-get update && apt-get -y install python3.6-dev

ADD itest.sh /itest.sh

CMD /itest.sh
