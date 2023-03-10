FROM tomcat:8.0-jre8

ADD ./server.xml /usr/local/tomcat/conf/

# Install aws cli tool for S3 sync of MD
RUN apt update && \
    apt install --no-install-recommends -y python-pip augeas-tools augeas-lenses && \
    pip install --no-cache-dir awscli && \
    rm -rf /var/lib/apt/lists/*

ADD . /

LABEL "io.upkick.warn_only"="true"

# Enable Gzip compression on tomcat
RUN cat /enable_gzip.augtool | augtool --noload --noautoload --echo

RUN cd /usr/local/tomcat/webapps && \
  unzip -d geonetwork geonetwork.war && \
  rm geonetwork.war

ENTRYPOINT ["/docker-entrypoint.sh", "catalina.sh", "run"]
