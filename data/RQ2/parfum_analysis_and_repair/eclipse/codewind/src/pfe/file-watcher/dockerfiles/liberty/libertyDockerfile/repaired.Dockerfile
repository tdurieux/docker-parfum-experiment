FROM websphere-liberty:19.0.0.9-webProfile7
LABEL maintainer="IBM Java Engineering at IBM Cloud"
COPY /target/liberty/wlp/usr/servers/defaultServer /config/
COPY /target/liberty/wlp/usr/shared/resources /config/resources/
COPY /src/main/liberty/config/jvmbx.options /config/jvm.options
# Grant write access to apps folder, this is to support old and new docker versions.
# Liberty document reference : https://hub.docker.com/_/websphere-liberty/
USER root
RUN chmod g+w /config/apps
RUN configure.sh
USER 1001
ENV HOME /home/default

USER root

COPY --from=ibmjava:8-sdk /opt/ibm/java $HOME/java

RUN set -eux; \
    apt-get update \
    && apt-get install -y --no-install-recommends wget openssl \
    && rm -rf /var/lib/apt/lists/*; \
    mkdir -p $HOME/mvn &&\
    MAVEN_VERSION=$(wget -qO- https://repo.maven.apache.org/maven2/org/apache/maven/apache-maven/maven-metadata.xml | sed -n 's/\s*<release>\(.*\)<.*>/\1/p') &&\
    wget -q -U UA_IBM_JAVA_Docker -O $HOME/mvn/apache-maven-${MAVEN_VERSION}-bin.tar.gz https://search.maven.org/remotecontent?filepath=org/apache/maven/apache-maven/${MAVEN_VERSION}/apache-maven-${MAVEN_VERSION}-bin.tar.gz &&\
    tar xf $HOME/mvn/apache-maven-${MAVEN_VERSION}-bin.tar.gz -C $HOME/mvn &&\
    mv $HOME/mvn/apache-maven-${MAVEN_VERSION} $HOME/mvn/apache-maven &&\
    rm -f $HOME/mvn/apache-maven-${MAVEN_VERSION}-bin.tar.gz; \
    apt-get purge --auto-remove -y wget; \
    rm -rf /var/lib/apt/lists/*;

USER 1001

RUN mkdir -m 777 -p /config/resources

ENV JAVA_HOME=$HOME/java \
    PATH=$HOME/java/jre/bin:$HOME/mvn/apache-maven/bin:$PATH