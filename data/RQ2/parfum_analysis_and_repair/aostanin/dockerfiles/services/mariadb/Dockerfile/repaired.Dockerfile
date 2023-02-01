FROM aostanin/debian

RUN apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0xcbcb082a1bb943db
RUN echo 'deb http://ftp.osuosl.org/pub/mariadb/repo/5.5/debian wheezy main' > /etc/apt/sources.list.d/mariadb.list
RUN apt-get update -q && apt-get install --no-install-recommends -qy mariadb-server && rm -rf /var/lib/apt/lists/*;

ADD start.sh /start.sh

VOLUME ["/data"]
EXPOSE 3306

CMD ["/start.sh"]
