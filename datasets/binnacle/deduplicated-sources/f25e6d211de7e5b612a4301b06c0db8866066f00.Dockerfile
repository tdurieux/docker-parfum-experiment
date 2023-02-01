FROM maven:3.6-jdk-8

# ----------------- Add git client

RUN apt-get install git

# ----------------- Add node
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - \
    && apt-get install -y nodejs

# ----------------- Add maven agent
ARG MAVEN_AGENT_URL=https://oss.sonatype.org/content/repositories/snapshots/ms/dew/dew-maven-agent/2.0.0-SNAPSHOT/dew-maven-agent-2.0.0-20190614.073115-1.jar

RUN mkdir -p /opt/maven/ \
    && curl -o /opt/maven/dew-maven-agent.jar $MAVEN_AGENT_URL

# Use a custom settings.xml file
# "/opt/maven/settings.xml" will be mounted by kubernetes ConfigMap in the CI/CD process
RUN echo '<?xml version="1.0" encoding="UTF-8"?>\n<settings>\n</settings>' > /opt/maven/settings.xml \
    && sed -i 's/\${CLASSWORLDS_LAUNCHER} "$@"/\${CLASSWORLDS_LAUNCHER} -s \/opt\/maven\/settings.xml "$@"/g' /usr/share/maven/bin/mvn

ENV MAVEN_OPTS="-javaagent:/opt/maven/dew-maven-agent.jar -Dmaven.repo.local=.m2 -Dorg.apache.maven.user-settings=/opt/maven/settings.xml"

CMD ["sh"]
