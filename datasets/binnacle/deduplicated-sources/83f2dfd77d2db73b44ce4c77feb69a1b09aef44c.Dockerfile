FROM ubuntu:trusty
# based on wurstmeister
MAINTAINER Anton Khramov <anton@endocode.com>

RUN apt-get update && apt-get dist-upgrade -y
RUN apt-get install -y tar openjdk-7-jre-headless wget
# python topology requirements and supervisord
RUN apt-get install -y python-setuptools python-virtualenv supervisor

# cleanup image
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN wget -q -O - http://apache.mirror.digionline.de/storm/apache-storm-0.9.2-incubating/apache-storm-0.9.2-incubating.tar.gz | tar -xzf - -C /opt

ENV STORM_HOME /opt/apache-storm-0.9.2-incubating
RUN groupadd storm; useradd --gid storm --home-dir /home/storm --create-home --shell /bin/bash storm; chown -R storm:storm $STORM_HOME; mkdir /var/log/storm ; chown -R storm:storm /var/log/storm

RUN ln -s $STORM_HOME/bin/storm /usr/bin/storm

ADD storm.yaml $STORM_HOME/conf/storm.yaml
ADD cluster.xml $STORM_HOME/logback/cluster.xml
ADD config-supervisord.sh /usr/bin/config-supervisord.sh
ADD start-supervisor.sh /usr/bin/start-supervisor.sh 

RUN echo [supervisord] | tee -a /etc/supervisor/supervisord.conf ; echo nodaemon=true | tee -a /etc/supervisor/supervisord.conf
