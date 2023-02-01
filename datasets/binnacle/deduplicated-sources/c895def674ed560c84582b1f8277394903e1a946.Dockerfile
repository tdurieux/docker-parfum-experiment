FROM openjdk:8-jre-alpine

ENV TOMCAT_VERSION=8.5.28

RUN apk add --update \
      bash \
      unzip \
      ttf-dejavu \
    && rm -rf /var/cache/apk/*

COPY ./target/*.zip /tmp/
    
# Unzip war into webapps dir && Remove temporal ws war && Make .openl dir
RUN unzip /tmp/*.zip -d /usr/local/ && rm /tmp/*.zip

RUN chmod +x /usr/local/apache-tomcat-${TOMCAT_VERSION}/*.sh && chmod +x /usr/local/apache-tomcat-${TOMCAT_VERSION}/bin/*.sh

WORKDIR /usr/local/apache-tomcat-${TOMCAT_VERSION}

EXPOSE 8080

#Start Tomcat
CMD ./start.sh && tail -f /dev/null
