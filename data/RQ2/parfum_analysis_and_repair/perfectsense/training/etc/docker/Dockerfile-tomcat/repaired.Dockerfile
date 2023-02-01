FROM brightspot/tomcat:9-jdk11

# Restore storage into container. To back up (execute from project root):
ADD ./data/tomcat-storage.tar.gz /servers/tomcat/storage/
USER root
RUN chown -R tomcat:tomcat /servers/tomcat/storage/
USER tomcat
VOLUME /servers/tomcat/storage