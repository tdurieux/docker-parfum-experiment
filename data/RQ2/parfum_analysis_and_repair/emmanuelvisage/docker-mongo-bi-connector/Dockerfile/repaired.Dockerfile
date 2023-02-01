FROM debian:jessie
MAINTAINER Emmanuel Marboeuf <emmanuel@visage.jobs>

RUN apt-get update && apt-get install --no-install-recommends -y openssl libssl-dev && rm -rf /var/lib/apt/lists/*;

ADD ./schema/mongomysqlmap.drdl /etc/mongodb-bi-connector/schema/mongomysqlmap.drdl

ADD bin /usr/local/bin
RUN chmod -R 755 /usr/local/bin

EXPOSE 3307