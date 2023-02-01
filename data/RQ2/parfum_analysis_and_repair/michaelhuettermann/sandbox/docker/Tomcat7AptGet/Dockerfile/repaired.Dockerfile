FROM michaelhuettermann/infra
MAINTAINER Michael Huettermann

# Install curl
RUN apt-get -y --no-install-recommends install curl && rm -rf /var/lib/apt/lists/*;

# Install tomcat
RUN apt-get -y --no-install-recommends install tomcat7 && rm -rf /var/lib/apt/lists/*;
RUN echo "JAVA_HOME=/usr/lib/jvm/java-7-oracle" >> /etc/default/tomcat7

ADD run.sh /root/run.sh
RUN chmod +x /root/run.sh

RUN curl -f -o /var/lib/tomcat7/webapps/all.war https://dl.bintray.com/michaelhuettermann/meow/all-1.0.0-GA.war

EXPOSE 8080

CMD ["/root/run.sh"]


