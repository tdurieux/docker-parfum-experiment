FROM ubuntu
MAINTAINER Maluuba Infrastructure Team <infrastructure@maluuba.com>

EXPOSE 8080

RUN apt-get -qq update
RUN apt-get -qq upgrade

RUN apt-get -qq -y --no-install-recommends install openjdk-7-jre && rm -rf /var/lib/apt/lists/*;
RUN apt-get -qq -y --no-install-recommends install tomcat7 && rm -rf /var/lib/apt/lists/*;
RUN apt-get -qq -y --no-install-recommends install curl && rm -rf /var/lib/apt/lists/*;
RUN apt-get -qq -y --no-install-recommends install bash && rm -rf /var/lib/apt/lists/*;

ADD start-tomcat.sh /opt/start-tomcat.sh
RUN chmod +x /opt/start-tomcat.sh

RUN mv /etc/cron.daily/logrotate /etc/cron.hourly/logrotate

ADD logrotate /etc/logrotate.d/tomcat7
RUN chmod 644 /etc/logrotate.d/tomcat7

# Setup UTF * based terminal
RUN locale-gen en_US.UTF-8 
ENV LANG en_US.UTF-8 
ENV LANGUAGE en_US:en 
ENV LC_ALL en_US.UTF-8 

ENTRYPOINT ["/opt/start-tomcat.sh"]
