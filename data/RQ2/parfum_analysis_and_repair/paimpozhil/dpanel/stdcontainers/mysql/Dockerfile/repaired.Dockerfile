FROM phusion/baseimage:0.9.9

ENV HOME /root

RUN /etc/my_init.d/00_regen_ssh_host_keys.sh


# Some Environment Variables
ENV    DEBIAN_FRONTEND noninteractive

# MySQL Installation
RUN apt-get update && apt-get install --no-install-recommends -y mysql-server && rm -rf /var/lib/apt/lists/*;
RUN echo "mysql-server mysql-server/root_password password root" | debconf-set-selections
RUN echo "mysql-server mysql-server/root_password_again password root" | debconf-set-selections


ADD build/my.cnf    /etc/mysql/my.cnf

RUN mkdir           /etc/service/mysql
ADD build/mysql.sh  /etc/service/mysql/run
RUN chmod +x        /etc/service/mysql/run



ADD build/setup.sh  /etc/mysql/mysql_setup.sh
RUN chmod +x        /etc/mysql/mysql_setup.sh

ADD dpanel_ssh_key.pub /tmp/your_key
RUN cat /tmp/your_key >> /root/.ssh/authorized_keys && rm -f /tmp/your_key

EXPOSE 3306
# END MySQL Installation

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

CMD ["/sbin/my_init"]

