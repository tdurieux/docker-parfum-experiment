FROM debian:jessie
MAINTAINER Evan Hazlett <ejhazlett@gmail.com>
RUN apt-get update && apt-get install --no-install-recommends -y openjdk-7-jre-headless wget && rm -rf /var/lib/apt/lists/*;
RUN ( wget -O /tmp/tomcat7.tar.gz https://mirror.cogentco.com/pub/apache/tomcat/tomcat-7/v7.0.57/bin/apache-tomcat-7.0.57.tar.gz && \
    cd /opt && \
    tar zxf /tmp/tomcat7.tar.gz && \
    mv /opt/apache-tomcat* /opt/tomcat && \
    rm /tmp/tomcat7.tar.gz)
COPY ./run.sh /usr/local/bin/run
EXPOSE 8080
CMD ["/bin/sh", "-e", "/usr/local/bin/run"]
