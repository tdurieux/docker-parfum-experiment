FROM ibmjava:8-sfj
LABEL maintainer="Eclipse Codewind"

ENV JAVA_OPTS=""
ENTRYPOINT [ "sh", "-c", "java $JAVA_OPTS -Djava.security.egd=file:/dev/./urandom -jar /app.jar" ]
EXPOSE 8080

COPY --from=ibmjava:8-sdk /opt/ibm/java /root/java

RUN mkdir -p /opt/mvn &&\
    MAVEN_VERSION=$(wget -qO- https://repo.maven.apache.org/maven2/org/apache/maven/apache-maven/maven-metadata.xml | sed -n 's/\s*<release>\(.*\)<.*>/\1/p') &&\
    wget -q -U UA_IBM_JAVA_Docker -O /opt/mvn/apache-maven-${MAVEN_VERSION}-bin.tar.gz https://search.maven.org/remotecontent?filepath=org/apache/maven/apache-maven/${MAVEN_VERSION}/apache-maven-${MAVEN_VERSION}-bin.tar.gz &&\
    tar xf /opt/mvn/apache-maven-${MAVEN_VERSION}-bin.tar.gz -C /opt/mvn &&\
    mv /opt/mvn/apache-maven-${MAVEN_VERSION} /opt/mvn/apache-maven &&\
    rm -f /opt/mvn/apache-maven-${MAVEN_VERSION}-bin.tar.gz;

RUN mkdir -m 777 -p /config/resources

ENV JAVA_HOME=/root/java \
    PATH=/root/java/jre/bin:/opt/mvn/apache-maven/bin:$PATH