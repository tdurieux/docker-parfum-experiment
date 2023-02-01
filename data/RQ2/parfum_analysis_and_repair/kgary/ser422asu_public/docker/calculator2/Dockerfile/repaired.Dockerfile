FROM ubuntu:latest
RUN apt-get -y update && apt-get -y upgrade
RUN apt-get -y --no-install-recommends install openjdk-8-jdk wget && rm -rf /var/lib/apt/lists/*;
RUN mkdir /usr/local/tomcat
RUN wget https://www-us.apache.org/dist/tomcat/tomcat-8/v8.5.39/bin/apache-tomcat-8.5.39.tar.gz -O /tmp/tomcat.tar.gz
RUN cd /tmp && tar xvfz tomcat.tar.gz && rm tomcat.tar.gz
RUN cp -Rv /tmp/apache-tomcat-8.5.39/* /usr/local/tomcat/
EXPOSE 8080
CMD /usr/local/tomcat/bin/catalina.sh run
