# Multi-stage build (Docker 17.05 or higher)

# build stage
#############
FROM centos:7 AS build-env
LABEL Author="Michal Karm Babacek <karm@redhat.com>"
WORKDIR /opt
ENV MVN_VERSION  3.6.0
ENV JAVA_VERSION 11
ENV M2_HOME /opt/apache-maven-${MVN_VERSION}
ENV JAVA_HOME /usr/lib/jvm/jre-${JAVA_VERSION}-openjdk
RUN yum install java-${JAVA_VERSION}-openjdk-devel unzip -y && rm -rf /var/cache/yum
RUN curl -f -L -O https://www-eu.apache.org/dist/maven/maven-3/${MVN_VERSION}/binaries/apache-maven-${MVN_VERSION}-bin.zip && \
    unzip apache-maven-${MVN_VERSION}-bin.zip
COPY src ./src
COPY pom.xml ./
COPY Container/settings.xml /root/.m2/settings.xml
COPY Container/start.sh /opt/
RUN  ./apache-maven-${MVN_VERSION}/bin/mvn package -Pthorntail && \
     unzip target/mp-starter-hollow-thorntail.jar -d target/mp-starter-hollow-thorntail


# prod stage
#############
FROM centos:7
LABEL Author="Michal Karm Babacek <karm@redhat.com>"
ENV JAVA_VERSION 11
RUN yum install java-${JAVA_VERSION}-openjdk -y && yum clean all && \
    rm -rf /var/cache/yum /tmp/* && useradd -s /sbin/nologin wildfly
EXPOSE 8080/tcp
USER wildfly
WORKDIR /opt/
COPY --from=build-env --chown=wildfly:wildfly /opt/target/mp-starter-hollow-thorntail /opt/mp-starter-hollow-thorntail
COPY --from=build-env --chown=wildfly:wildfly /opt/start.sh /opt/target/mp-starter.war /opt/
CMD ["/opt/start.sh"]
