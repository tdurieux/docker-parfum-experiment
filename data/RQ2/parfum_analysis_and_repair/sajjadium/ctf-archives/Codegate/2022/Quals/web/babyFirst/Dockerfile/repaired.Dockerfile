FROM ubuntu:20.04

RUN apt-get -y update && apt-get -y --no-install-recommends install software-properties-common && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y openjdk-11-jdk && rm -rf /var/lib/apt/lists/*;

RUN apt-get -y --no-install-recommends install wget && rm -rf /var/lib/apt/lists/*;
RUN mkdir /usr/local/tomcat
RUN wget https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.75/bin/apache-tomcat-8.5.75.tar.gz -O /tmp/tomcat.tar.gz
RUN cd /tmp && tar xvfz tomcat.tar.gz && rm tomcat.tar.gz
RUN cp -Rv /tmp/apache-tomcat-8.5.75/* /usr/local/tomcat/
RUN rm -rf /tmp/* && rm -rf /usr/local/tomcat/webapps/

COPY src/ROOT/ /usr/local/tomcat/webapps/ROOT/
COPY flag /flag
COPY start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]

