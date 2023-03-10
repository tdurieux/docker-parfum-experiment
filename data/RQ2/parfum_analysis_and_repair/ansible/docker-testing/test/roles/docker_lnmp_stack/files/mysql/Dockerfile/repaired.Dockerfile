# MySQL

FROM ubuntu:14.04

# Disable any prompts for apt-get
ENV DEBIAN_FRONTEND noninteractive

# Get some security updates
RUN apt-get update && apt-get -y --no-install-recommends install mysql-server && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y upgrade

# See readme.md for more information about the accounts and passwords
#
RUN echo "mysql-server mysql-server/root_password password root" | debconf-set-selections
RUN echo "mysql-server mysql-server/root_password_again password root" | debconf-set-selections

# install mysql


# add our my.cnf and setup script
ADD conf/my.cnf /etc/mysql/my.cnf
ADD build/setup.sh /home/setup.sh
RUN chmod +x /home/setup.sh

# Define mountable directories.
VOLUME ["/var/lib/mysql"]
# Define working directory.
# Mount with `-v <data-dir>:/var/lib/mysql`
WORKDIR /var/lib/mysql

# expose service port
EXPOSE 3306

# Start mysqld
CMD ["/home/setup.sh"]
