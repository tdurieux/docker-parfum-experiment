FROM python:2.7

MAINTAINER Sławek Ehlert <slafs@op.pl>

RUN apt-get -qq update && apt-get install --no-install-recommends -y -q netcat && rm -rf /var/lib/apt/lists/*;

RUN mkdir /tests

ADD test.sh /tests/

RUN pip install --no-cache-dir raven

WORKDIR /tests

CMD ["/bin/bash", "./test.sh"]
