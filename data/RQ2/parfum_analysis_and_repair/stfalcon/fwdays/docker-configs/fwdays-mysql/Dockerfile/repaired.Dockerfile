FROM debian:stretch
MAINTAINER Evgeniy Gurinovich "jeka@stfalcon.com"
RUN apt-get update && apt-get install --no-install-recommends -y wget curl ca-certificates procps locales zip apt-transport-https gnupg2 && rm -rf /var/lib/apt/lists/*;
RUN wget https://repo.percona.com/apt/percona-release_0.1-4.stretch_all.deb -O /tmp/percona.deb
RUN dpkg -i /tmp/percona.deb && rm /tmp/percona.deb && apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y percona-server-server-5.6 mysqltuner && rm -rf /var/lib/apt/lists/*;
ADD configs/my.cnf /etc/mysql/my.cnf
ADD configs/start /usr/local/bin/start
RUN chmod a+x /usr/local/bin/start
CMD /usr/local/bin/start
