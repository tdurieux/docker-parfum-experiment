FROM debian

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get -y --no-install-recommends install mysql-server-core-5.5 mysql-server-5.5 && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y upgrade


ADD run-mysqld /run-mysqld

EXPOSE 3306

VOLUME ["/mysql"]

CMD ["/run-mysqld"]
