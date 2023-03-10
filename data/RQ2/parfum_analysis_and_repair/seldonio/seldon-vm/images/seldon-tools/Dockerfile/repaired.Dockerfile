FROM ubuntu:trusty

ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive

RUN ( apt-get update && \
     apt-get install --no-install-recommends -y python python-pip make python-dev zookeeper curl jq wget unzip libmysqlclient-dev mysql-client-core-5.6 && \
     apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*)

RUN pip install --no-cache-dir unicodecsv
RUN pip install --no-cache-dir MySQL-python
RUN pip install --no-cache-dir kazoo

ADD apps /apps

VOLUME ["/seldon-tools"]

ADD scripts /seldon-tools/scripts

# Define default command.
CMD ["/apps/bin/keep_alive"]

