FROM ubuntu:xenial

RUN apt-get -qq update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y solr-tomcat && \
    ln -s /var/log/tomcat7/ /usr/share/tomcat7/logs && \
    ln -s /etc/tomcat7/ /usr/share/tomcat7/conf

COPY conf/solr/conf/schema.xml /etc/solr/conf/

EXPOSE 8080

CMD ["/usr/share/tomcat7/bin/catalina.sh", "run"]
