# Docker container with Sysbench and MySQL Server
# installed for running MySQL benchmark tests

FROM tutum/mysql
MAINTAINER Chris Collins <collins.christopher@gmail.com>

ADD run2.sh /run2.sh
ADD create_mysql_admin_user.sh /create_mysql_admin_user.sh
RUN apt-get install --no-install-recommends -y sysbench && rm -rf /var/lib/apt/lists/*;

CMD ["/run2.sh"]
