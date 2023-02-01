FROM REPLACE_NULLWORKLOAD_UBUNTU

# redis-install-pip
RUN pip3 install --no-cache-dir redis
# redis-install-pip

# mysql-install-pm
RUN echo "mysql-server-5.7 mysql-server/root_password password temp4now" | sudo debconf-set-selections; echo "mysql-server-5.7 mysql-server/root_password_again password temp4now" | sudo debconf-set-selections
RUN apt-get update
RUN apt-get install --no-install-recommends -y mysql-server python3-mysqldb python3-pip python3-dev libmysqlclient-dev && rm -rf /var/lib/apt/lists/*;
# mysql-install-pm

# sysbench-ARCHx86_64-install-pm
RUN apt-get install --no-install-recommends -y lsb-release && rm -rf /var/lib/apt/lists/*;
RUN lsb_release -sc
RUN wget https://repo.percona.com/apt/percona-release_latest.$(lsb_release -sc)_all.deb
RUN sudo dpkg -i percona-release_latest.$(lsb_release -sc)_all.deb
RUN apt-get update; apt-get install --no-install-recommends -y sysbench sysbench-tpcc && rm -rf /var/lib/apt/lists/*;
# sysbench-ARCHx86_64-install-pm

# sysbench-ARCHppc64le-install-pm
RUN apt-get install --no-install-recommends -y lsb-release && rm -rf /var/lib/apt/lists/*;
RUN lsb_release -sc
RUN wget https://repo.percona.com/apt/percona-release_latest.$(lsb_release -sc)_all.deb
RUN sudo dpkg -i percona-release_latest.$(lsb_release -sc)_all.deb
RUN apt-get update; apt-get install --no-install-recommends -y sysbench lua5.3 && rm -rf /var/lib/apt/lists/*;
RUN wget -N -q -P /home/REPLACE_USERNAME https://github.com/Percona-Lab/sysbench-tpcc/archive/v2.2.tar.gz
RUN /bin/true; cd /home/REPLACE_USERNAME; tar -xzvf /home/REPLACE_USERNAME/v2.2.tar.gz; rm /home/REPLACE_USERNAME/v2.2.tar.gz cd sysbench-tpcc-*
# sysbench-ARCHppc64le-install-pm

RUN chown -R REPLACE_USERNAME:REPLACE_USERNAME /home/REPLACE_USERNAME
