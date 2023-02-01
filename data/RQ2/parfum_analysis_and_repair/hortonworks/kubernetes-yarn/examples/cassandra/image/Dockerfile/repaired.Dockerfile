FROM google/debian:wheezy

COPY cassandra.list /etc/apt/sources.list.d/cassandra.list

RUN gpg --batch --keyserver pgp.mit.edu --recv-keys F758CE318D77295D
RUN gpg --batch --export --armor F758CE318D77295D | apt-key add -

RUN gpg --batch --keyserver pgp.mit.edu --recv-keys 2B5C1B00
RUN gpg --batch --export --armor 2B5C1B00 | apt-key add -

RUN gpg --batch --keyserver pgp.mit.edu --recv-keys 0353B12C
RUN gpg --batch --export --armor 0353B12C | apt-key add -

RUN apt-get update && apt-get -qq --no-install-recommends -y install cassandra && rm -rf /var/lib/apt/lists/*;

COPY cassandra.yaml /etc/cassandra/cassandra.yaml
COPY run.sh /run.sh
COPY kubernetes-cassandra.jar /kubernetes-cassandra.jar
RUN chmod a+x /run.sh

CMD /run.sh
