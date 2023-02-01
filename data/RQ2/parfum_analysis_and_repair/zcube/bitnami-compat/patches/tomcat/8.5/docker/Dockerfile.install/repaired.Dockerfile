RUN install_packages wget libtcnative-1

ENV TOMCAT_MAJOR {{{VERSION_MAJOR}}}
ENV TOMCAT_VERSION {{{VERSION}}}

RUN mkdir -p /opt/bitnami \
    && cd /opt/bitnami \
    && wget https://downloads.apache.org/tomcat/tomcat-${TOMCAT_MAJOR}/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz \
    && wget https://downloads.apache.org/tomcat/tomcat-${TOMCAT_MAJOR}/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz.sha512 \
    && echo $(cat apache-tomcat-${TOMCAT_VERSION}.tar.gz.sha512) | sha512sum --check - \
    && tar -xzf apache-tomcat-${TOMCAT_VERSION}.tar.gz \
    && mv apache-tomcat-${TOMCAT_VERSION}/ tomcat \
    && rm -rf apache-tomcat-${TOMCAT_VERSION}.tar.gz* \
    && chown 1001:1001 -R /opt/bitnami/tomcat