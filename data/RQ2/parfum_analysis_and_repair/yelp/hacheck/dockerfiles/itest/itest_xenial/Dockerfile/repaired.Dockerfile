FROM docker-dev.yelpcorp.com/xenial_yelp
MAINTAINER John Billings <billings@yelp.com>

RUN apt-get update && \
    apt-get install -y --no-install-recommends software-properties-common && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && apt-get -y --no-install-recommends install python3.6-dev && rm -rf /var/lib/apt/lists/*;

ADD itest.sh /itest.sh

CMD /itest.sh
