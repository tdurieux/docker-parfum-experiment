FROM fabric8/java-centos-openjdk8-jre:1.0.0

MAINTAINER rhuss@redhat.com

EXPOSE 8080

ENV JETTY_VERSION 7.6.17.v20150415
ENV DEPLOY_DIR /maven

RUN curl -f https://download.eclipse.org/jetty/${JETTY_VERSION}/dist/jetty-distribution-${JETTY_VERSION}.tar.gz -o /tmp/jetty.tar.gz \
 && cd /opt && tar zxvf /tmp/jetty.tar.gz \
 && ln -s /opt/jetty-distribution-${JETTY_VERSION} /opt/jetty \
 && rm /tmp/jetty.tar.gz

# Startup script
ADD deploy-and-run.sh /opt/jetty/bin/
ADD jetty-logging.xml /opt/jetty/etc/
RUN chmod a+x /opt/jetty/bin/deploy-and-run.sh

ENV JETTY_HOME /opt/jetty
ENV PATH $PATH:$JETTY_HOME/bin

CMD /opt/jetty/bin/deploy-and-run.sh
