FROM svenruppert/maven-3.5-no-jdk:maven-3.5.3
MAINTAINER sven.ruppert@gmail.com

ARG USER_HOME_DIR="/root"

RUN curl -f -sL https://github.com/shyiko/jabba/raw/master/install.sh | \
    JABBA_COMMAND="install openjdk@1.10.0-1 -o /jdk" bash

ENV JAVA_HOME /jdk
ENV PATH $JAVA_HOME/bin:$PATH
ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_CONFIG "$USER_HOME_DIR/.m2"

RUN java -version
RUN mvn -version


ENTRYPOINT ["/usr/local/bin/mvn-entrypoint.sh"]
CMD ["mvn"]
