FROM REPLACE_NULLWORKLOAD_UBUNTU

# java-install-pm
RUN apt-get update; apt install --no-install-recommends -y openjdk-8-jre:REPLACE_ARCH3 openjdk-8-jre-headless:REPLACE_ARCH3 openjdk-8-jdk:REPLACE_ARCH3 && rm -rf /var/lib/apt/lists/*;
RUN sudo apt --fix-broken -y install
# java-install-pm

# cassandra-install-man
RUN wget -N -v -P /home/REPLACE_USERNAME https://launchpadlibrarian.net/109052632/python-support_1.0.15_all.deb; dpkg -i /home/REPLACE_USERNAME/python-support*.deb; sudo apt --fix-broken -y install
RUN wget -N -v -P /home/REPLACE_USERNAME https://dl.bintray.com/apache/cassandra/pool/main/c/cassandra/cassandra_2.1.20_all.deb
RUN dpkg -i /home/REPLACE_USERNAME/cassandra*.deb; sudo apt --fix-broken -y install
# cassandra-install-man

# cassandra-tools-install-man
RUN wget -N -v -P /home/REPLACE_USERNAME https://dl.bintray.com/apache/cassandra/pool/main/c/cassandra/cassandra-tools_2.1.20_all.deb
RUN dpkg -i /home/REPLACE_USERNAME/cassandra-tools*.deb; sudo apt --fix-broken -y install
# service_stop_disable cassandra
# cassandra-tools-install-man

# mongo-install-pm
RUN apt-get install --no-install-recommends -y mongodb && rm -rf /var/lib/apt/lists/*;
RUN sed -i "s/.*bind_ip.*/bind_ip=0.0.0.0/" /etc/mongodb.conf
# service_stop_disable mongodb
# mongo-install-pm

# redis-install-pm
RUN apt-get install --no-install-recommends -y redis-server && rm -rf /var/lib/apt/lists/*;
RUN sed -i "s/.*bind.*/bind 0.0.0.0/" /etc/redis/redis.conf
# service_stop_disable redis-server
# redis-install-pm

# ycsb-install-man
RUN wget -N -q -P /home/REPLACE_USERNAME https://github.com/brianfrankcooper/YCSB/releases/download/0.5.0/ycsb-0.5.0.tar.gz; cd /home/REPLACE_USERNAME; tar -xvzf ycsb-*.tar.gz; rm ycsb-*.tar.gz sudo rm ycsb*.gz; sudo mv ycsb-* YCSB
# ycsb-install-man
RUN chown -R REPLACE_USERNAME:REPLACE_USERNAME /home/REPLACE_USERNAME
