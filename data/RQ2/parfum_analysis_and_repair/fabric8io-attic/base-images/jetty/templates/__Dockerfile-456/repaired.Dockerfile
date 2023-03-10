FROM {{= fp.config.version.from.jdk7 }}:{{= fp.config.version.from.version }}

MAINTAINER {{= fp.maintainer }}

EXPOSE 8080 8778

ENV JETTY_VERSION {{= fp.config.version.version }}
ENV DEPLOY_DIR /maven

RUN curl -f {{= fp.config.version.downloadUrl }} -o /tmp/jetty.zip \
 && cd /opt && jar xvf /tmp/jetty.zip \
 && ln -s /opt/jetty-${JETTY_VERSION} /opt/jetty \
 && rm /tmp/jetty.zip

# Startup script
ADD deploy-and-run.sh /opt/jetty/bin/
RUN chmod a+x /opt/jetty/bin/deploy-and-run.sh

ENV JETTY_HOME /opt/jetty
ENV PATH $PATH:$JETTY_HOME/bin

CMD /opt/jetty/bin/deploy-and-run.sh
