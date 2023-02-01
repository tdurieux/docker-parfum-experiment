# MySQL 5.5 (gewo/mysql)
FROM gewo/base
MAINTAINER Gebhard Wöstemeyer <g.woestemeyer@gmail.com>

RUN \
  apt-get update && \
  apt-get install --no-install-recommends -y mysql-server-5.5 && \
  apt-get clean && rm -rf /var/lib/apt/lists/*;

ADD my.cnf /etc/mysql/my.cnf
ADD start_mysqld /usr/local/bin/start_mysqld
RUN chmod 755 /usr/local/bin/start_mysqld

RUN mkdir /data
RUN mkdir /logs
VOLUME ["/data"]
VOLUME ["/logs"]

EXPOSE 3306
CMD ["start_mysqld"]
