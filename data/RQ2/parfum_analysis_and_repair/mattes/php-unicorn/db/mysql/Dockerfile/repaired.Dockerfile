FROM tianon/debian:wheezy
MAINTAINER Matthias Kadenbach <matthias.kadenbach@gmail.com>

RUN apt-get update && apt-get --force-yes --no-install-recommends -y install mysql-server && rm -rf /var/lib/apt/lists/*;

RUN sed -i -e 's/bind-address/# bind-address/' /etc/mysql/my.cnf
RUN mysql_install_db --user=mysql

# delete anonymous users, set password "root" for user root,
# allow remote access for user root, delete database "test"
RUN /etc/init.d/mysql start && mysql -S /var/run/mysqld/mysqld.sock -u root -e "DELETE FROM mysql.user WHERE User = ''; UPDATE mysql.user SET Password=PASSWORD('root') WHERE User = 'root'; GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'root'; DROP DATABASE IF EXISTS test; FLUSH PRIVILEGES;"; /etc/init.d/mysql stop

# add start script
ADD start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

# expose ports
EXPOSE 3306

# run command
CMD ["start.sh"]
