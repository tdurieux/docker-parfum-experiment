# Ubuntu/precise is the main distribution
FROM ubuntu:precise

<<<<<<< HEAD
ENV http_proxy http://172.17.42.1:3128
ENV https_proxy http://172.17.42.1:3128

# sanitize all package lists
RUN echo > /etc/apt/sources.list
RUN echo deb http://archive.ubuntu.com/ubuntu/ precise main restricted universe multiverse > /etc/apt/sources.list.d/precise.list
RUN echo deb http://archive.ubuntu.com/ubuntu/ precise-updates main restricted universe multiverse >> /etc/apt/sources.list.d/precise.list
RUN echo deb http://archive.ubuntu.com/ubuntu/ precise-security main restricted universe multiverse >> /etc/apt/sources.list.d/precise.list
=======
RUN rm -rvf /var/lib/apt/lists/*
RUN apt-get update
RUN apt-get install --no-install-recommends -y libssl1.0.0 openssl postgresql-client && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y software-properties-common python-software-properties && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:webupd8team/java
>>>>>>> f7f2029bf9c65699c35e2d32ffe21d70422844cb

RUN rm -rvf /var/lib/apt/lists/*
RUN apt-get update
RUN apt-get install --no-install-recommends -y libssl1.0.0 openssl && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y software-properties-common python-software-properties && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:webupd8team/java

# add wget
RUN apt-get update
RUN echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN apt-get install --no-install-recommends -y wget oracle-java7-installer && rm -rf /var/lib/apt/lists/*;
<<<<<<< HEAD
=======

# add logstash sources list and install it
RUN wget -O - https://packages.elasticsearch.org/GPG-KEY-elasticsearch | apt-key add -
RUN echo 'deb http://packages.elasticsearch.org/logstashforwarder/debian stable main' | tee /etc/apt/sources.list.d/logstash.list
RUN apt-get update
RUN apt-get install --no-install-recommends -y logstash-forwarder && rm -rf /var/lib/apt/lists/*;

# add logstash conf
ADD logstash.conf /tmp/logstash.conf
>>>>>>> f7f2029bf9c65699c35e2d32ffe21d70422844cb

# install tigase
RUN wget 'https://projects.tigase.org/attachments/download/1409/tigase-server-5.2.1-b3461-dist-max.tar.gz' -O /tmp/tigase-server.tar.gz
RUN tar -xC /opt -zf /tmp/tigase-server.tar.gz && rm /tmp/tigase-server.tar.gz
RUN mv /opt/tigase-server* /opt/tigase-server

# prepare tigase
ADD tigase.conf /opt/tigase-server/etc/tigase.conf
ADD init.properties /opt/tigase-server/etc/init.properties
ADD admin-groovy/ /opt/tigase-server/scripts/admin/
ADD UnlimitedJCEPolicy/ /usr/lib/jvm/java-7-oracle/lib/security/
<<<<<<< HEAD
ADD tigase-server.jar /opt/tigase-server/jars/tigase-server.jar

# create hosting XMPP account
ADD create-hosting-account.sh /opt/tigase-server/create-hosting-account.sh
RUN bash /opt/tigase-server/create-hosting-account.sh

ENV http_proxy ""
ENV https_proxy ""

# run tigase
ENTRYPOINT cd /opt/tigase-server; java -version; ./scripts/tigase.sh run etc/tigase.conf; wait $!
=======
# Patched with https://projects.tigase.org/attachments/1475/tigase-ibr-cidr-whitelist.patch
ADD tigase-server.jar /opt/tigase-server/jars/tigase-server.jar

# run tigase
ENTRYPOINT ln -s /srv/secret/logstash-forwarder.crt /opt/logstash-forwarder/logstash-forwarder.crt; ln -s /srv/secret/logstash-forwarder.key /opt/logstash-forwarder/logstash-forwarder.key; /opt/logstash-forwarder/bin/logstash-forwarder -config /tmp/logstash.conf & cd /opt/tigase-server; java -version; ./scripts/tigase.sh run etc/tigase.conf; wait $!
>>>>>>> f7f2029bf9c65699c35e2d32ffe21d70422844cb
EXPOSE 5222 5269 5270 5290
